/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.flexunit.internals.runners {
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flex.lang.reflect.Klass;
	
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	
	import net.digitalprimates.fluint.monitor.TestMonitor;
	import net.digitalprimates.fluint.tests.TestCase;
	import net.digitalprimates.fluint.tests.TestSuite;
	import net.digitalprimates.fluint.ui.TestEnvironment;
	import net.digitalprimates.fluint.ui.TestRunner;
	
	import org.flexunit.runner.Description;
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.IRunner;
	import org.flexunit.runner.manipulation.IFilter;
	import org.flexunit.runner.manipulation.IFilterable;
	import org.flexunit.runner.notification.IRunNotifier;
	import org.flexunit.runner.notification.StoppedByUserException;
	import org.flexunit.token.AsyncTestToken;
	import org.flexunit.token.ChildResult;
	import org.flexunit.token.IAsyncTestToken;
	import org.flexunit.utils.ClassNameUtil;
	import org.fluint.uiImpersonation.IVisualTestEnvironment;
	import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;
	
	/**
	 * Runs the associated testClass that is passed into the <code>Fluint1ClassRunner</code>.
	 * 
	 */
	public class Fluint1ClassRunner implements IRunner, IFilterable {

		/**
		 * @private
		 */
		private static var testCase:Class;
		/**
		 * @private
		 */
		private static var testSuite:Class;
		/**
		 * @private
		 */
		private static var testMethod:Class;
		
		/**
		 * @private
		 */
		private var testClass:*;
		/**
		 * @private
		 */
		private var test:*;
		/**
		 * @private
		 */
		private var klassInfo:Klass;
		/**
		 * @private
		 */
		private var flexUnitTestEnvironmentBuilder:org.fluint.uiImpersonation.IVisualEnvironmentBuilder;
		/**
		 * @private
		 */
		private var flexUnitTestEnvironment:org.fluint.uiImpersonation.IVisualTestEnvironment;
		/**
		 * @private
		 */
		private var testRunner:TestRunner;
		/**
		 * @private
		 */
		private var token:AsyncTestToken;

		/**
		 * @private
		 */
		protected var stopRequested:Boolean = false;
		
		/**
		 * Constructor
		 *  
		 * @param clazz is an XML <code>Klass</code> that allows the associated <code>Class</code>
		 * to be called and run methods associated with the <code>Class</code>.
		 * 
		 */
		public function Fluint1ClassRunner( clazz:* ) {
			super();

			klassInfo = new Klass( clazz );
			testClass = clazz;
			test = klassInfo.constructor.newInstance();

			flexUnitTestEnvironmentBuilder = org.fluint.uiImpersonation.VisualTestEnvironmentBuilder.getInstance();
			flexUnitTestEnvironment = flexUnitTestEnvironmentBuilder.buildVisualTestEnvironment();
			
			if ( !testCase ) {
				testCase = getDefinitionByName( "net.digitalprimates.fluint.tests.TestCase" ) as Class;
				testSuite = getDefinitionByName( "net.digitalprimates.fluint.tests.TestSuite" ) as Class;
				testMethod = getDefinitionByName( "net.digitalprimates.fluint.tests.TestMethod" ) as Class;
			}
		}

		/**
		 * Returns the <code>Class</code> for a provided <code>Test</code>.
		 * 
		 * @param test The <code>Test</code> for which to obtain the <code>Class</code>.
		 * 
		 * @return the <code>Class</code> for a provided <code>Test</code>.
		 */
		public static function getClassFromTest( test:* ):Class {
			var name:String = getQualifiedClassName( test );
			return getDefinitionByName( name ) as Class;		
		}

		/**
		 * Runs the test class and updates the <code>notifier</code> on the status of running the tests.
		 * 
		 * @param notifier The notifier that is notified about issues encountered during the execution of the test class.
		 * @param previousToken The token that is to be notified when the runner has finished execution of the test class.
		 */
		public function run( notifier:IRunNotifier, previousToken:IAsyncTestToken ):void {
			if ( stopRequested ) {
				previousToken.sendResult( new StoppedByUserException() );
				return;
			}
			
			token = new AsyncTestToken( ClassNameUtil.getLoggerFriendlyClassName( this ) );
			token.parentToken = previousToken;
			token.addNotificationMethod( handleTestComplete );
			
			var fluintUnitTestEnvironment:net.digitalprimates.fluint.ui.TestEnvironment = new net.digitalprimates.fluint.ui.TestEnvironment();
			flexUnitTestEnvironment.addChild( fluintUnitTestEnvironment );

			testRunner = new TestRunner( createAdaptingMonitor( notifier ) );
			testRunner.testEnvironment = fluintUnitTestEnvironment;
			testRunner.addEventListener( TestRunner.TESTS_COMPLETE, handleAllTestsComplete );
			testRunner.startTests( [test] );
		}

		/**
		 * Ask that the tests run stop before starting the next test. Phrased politely because
		 * the test currently running will not be interrupted. 
		 */
		public function pleaseStop():void {
			stopRequested = true;
			
		}

		/**
		 * Handles the results when all of the tests are complete for the class.
		 * Removes all of the children from the <code>flexUnitTestEnvironment</code>.
		 * 
		 * Also calls <code>sendResult</code> on the token.parentToken.
		 * 
		 * @param event
		 * @see org.flexunit.token.AsyncTestToken
		 */
		protected function handleAllTestsComplete( event:Event ):void {
			//need to remove older environment
			flexUnitTestEnvironment.removeAllChildren();;
			token.parentToken.sendResult();
		}
		
		/**
		 * Handles the results of a single test completing. Removes all of the children from
		 * the <code>flexUnitTestEnvironment</code>.
		 * 
		 * Also calls <code>sendResult</code> on the token.parentToken contained in <code>result</code>.
		 * 
		 * @param result ChildResult - The results of the running test.
		 * @see org.flexunit.token.AsyncTestToken
		 */
		protected function handleTestComplete( result:ChildResult ):void {
			var token:AsyncTestToken = result.token;

			//need to remove older environment
			flexUnitTestEnvironment.removeAllChildren();

			token.parentToken.sendResult();
		}

		/**
		 * Creates an instance of the <code>FluintAdaptingListener</code> internal class and passes
		 * an <code>IRunNotifier</code> to it.
		 * @param notifier IRunNotifier
		 * @return TestMonitor
		 * 
		 */
 		public function createAdaptingMonitor( notifier:IRunNotifier ):TestMonitor {
			return new FluintAdaptingListener( notifier );
		}
		
		/**
		 * @private
		 */
		private var cachedDescription:IDescription;
		/**
		 * Returns an <code>IDescription</code> of the test class that the runner is running.
		 * @return IDescription of the cached description.
		 * 
		 */
		public function get description():IDescription {
			if ( !cachedDescription ) {
				cachedDescription = makeDescription( test );
			}
			
			return cachedDescription;
		}

	
		/**
		 * @private 
		 * Generates an <code>IDescription</code> for the provided <code>Test</code>.
		 * 
		 * @param test The <code>Test</code> ufor which to generate the <code>IDescription</code>.
		 * 
		 * @return an <code>IDescription</code> for the provided <code>Test</code>.
		 */
		private function makeDescription( test:* ):IDescription {
			var klassInfo:Klass;
			var clazz:Class;
			var name:String;
			var description:IDescription;
			var n:int;
			var tests:ICollectionView;
			var cursor:IViewCursor;

 			if ( test is testCase ) {
				var tc:* = test;
				clazz = getClassFromTest( tc );
				klassInfo = new Klass( clazz );
				description = Description.createTestDescription( klassInfo.asClass, klassInfo.name );
				n = tc.getTestCount();
				
				tests = tc.getTests();
				cursor = tests.createCursor();
				while ( !cursor.afterLast ) {
					description.addChild( makeDescription( cursor.current ) );
					cursor.moveNext();
				}					
				
				return description;
			} else if ( test is testSuite ) {
				var ts:* = test;
				clazz = getClassFromTest( ts );
				klassInfo = new Klass( clazz );

				name = klassInfo.name;
				description = Description.createSuiteDescription(name);
				n = ts.getTestCount();
				tests = ts.getTests();
				cursor = tests.createCursor();

				while ( !cursor.afterLast ) {
					description.addChild( makeDescription( cursor.current ) );
					cursor.moveNext();
				}

				return description;
			} else if ( test is XML ) {
				//We have a single method here
				return Description.createTestDescription( this.testClass, test.@name  );
			}

			return Description.EMPTY;		
		}
	
		/**
		 * @private
		 */
		private var appliedFilter:IFilter; 
		/**
		 * Will apply a <code>Filter</code> to the test object.
		 * @param filter Filter
		 * @see org.flexunit.runner.manipulation.Filter
		 */
		public function filter( filter:IFilter ):void {
			if ( filter ) {
				appliedFilter = filter;
				Object( test ).filter = filterWithIFilter;
			}
		}
		
		/**
		 * @private
		 */
		protected function filterWithIFilter( item:Object ):Boolean {
			return appliedFilter.shouldRun( makeDescription( item ) );
		}
	}
}
import flex.lang.reflect.Klass;

import net.digitalprimates.fluint.monitor.TestCaseResult;
import net.digitalprimates.fluint.monitor.TestMethodResult;
import net.digitalprimates.fluint.monitor.TestMonitor;
import net.digitalprimates.fluint.tests.TestCase;
import net.digitalprimates.fluint.tests.TestMethod;
import net.digitalprimates.fluint.tests.TestSuite;

import org.flexunit.internals.runners.Fluint1ClassRunner;
import org.flexunit.runner.Description;
import org.flexunit.runner.IDescription;
import org.flexunit.runner.notification.Failure;
import org.flexunit.runner.notification.IRunNotifier;
import org.flexunit.token.AsyncTestToken;	

class FluintAdaptingListener extends TestMonitor {
	private var notifier:IRunNotifier;

	public function FluintAdaptingListener( notifier:IRunNotifier ) {
		this.notifier = notifier;
	}
	
	override public function createTestMethodResult( testCase:TestCase, testMethod:TestMethod ):TestMethodResult {
		var testMethodResult:TestMethodResult = new AdaptingTestMethodResult( testMethod, Fluint1ClassRunner.getClassFromTest( testCase ), notifier );

		testMethodDictionary[ testMethod ] = testMethodResult;
		
		var testCaseResult:TestCaseResult = getTestCaseResult( testCase );
		testCaseResult.addTestMethodResult( testMethodResult );
		
		return testMethodResult;
	}	
}

class AdaptingTestMethodResult extends TestMethodResult {
	private var notifier:IRunNotifier;
	private var testClass:Class;
	private var testMethod:TestMethod;

	public function AdaptingTestMethodResult( testMethod:TestMethod, testClass:Class, notifier:IRunNotifier ) {		
		this.testMethod = testMethod;
		this.testClass = testClass;
		this.notifier = notifier;
		super( testMethod );
		notifier.fireTestStarted( getDescription() );
	}

	private function getDescription():IDescription {
		return Description.createTestDescription( testClass, testMethod.methodName );
	}

 	override public function set executed( value:Boolean ):void {
		super.executed = value;
		notifier.fireTestFinished( getDescription() );
	}	
	
	override public function set error( value : Error ):void {
		super.error = value;
		
		if ( value ) {
			notifier.fireTestFailure( new Failure( getDescription(), value ) );
		}
	}
}





