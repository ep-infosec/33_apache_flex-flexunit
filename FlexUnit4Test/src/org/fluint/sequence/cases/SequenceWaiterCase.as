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
package org.fluint.sequence.cases
{
	import org.flexunit.Assert;
	import org.flexunit.async.AsyncLocator;
	import org.flexunit.async.mocks.EventDispatcherMock;
	import org.flexunit.internals.runners.statements.IAsyncHandlingStatement;
	import org.flexunit.internals.runners.statements.mock.AsyncHandlingStatementMock;
	import org.fluint.sequence.SequenceWaiter;
	import org.fluint.sequence.mocks.SequenceRunnerMock;

	public class SequenceWaiterCase
	{
		protected var sequenceWaiter:SequenceWaiter;
		protected var target:EventDispatcherMock;
		protected var eventName:String;
		protected var timeout:int;
		protected var timeoutHandler:Function;
		
		
		[Before(description="Create an instance of the SequenceWaiter class")]
		public function createSequenceWaiter():void {
			target = new EventDispatcherMock();
			eventName = "testName";
			timeout = 2000;
			timeoutHandler = new Function();
			sequenceWaiter = new SequenceWaiter(target, eventName, timeout, timeoutHandler);
		}
		
		[After(description="Remove the reference to the instance of the SequenceWaiter class")]
		public function destroySequenceWaiter():void {
			sequenceWaiter = null;
			target = null;
			eventName = null;
			timeout = NaN;
			timeoutHandler = null;
		}
		
		[Test(description="Ensure that the target property is correctly obtained")]
		public function getTargetTest():void {
			Assert.assertEquals( target, sequenceWaiter.target );
		}
		
		[Test(description="Ensure that the eventName property is correctly obtained")]
		public function getEventNameTest():void {
			Assert.assertEquals( eventName, sequenceWaiter.eventName );
		}
		
		[Test(description="Ensure that the timeout property is correctly obtained")]
		public function getTimeoutTest():void {
			Assert.assertEquals( timeout, sequenceWaiter.timeout );
		}
		
		[Test(description="Ensure that the timeoutHandler property is correctly obtained")]
		public function getTimeoutHandlerTest():void {
			Assert.assertEquals( timeoutHandler, sequenceWaiter.timeoutHandler );
		}
		
		[Test(description="Ensure that the setupListeners function correctly operates")]
		public function setupListenersTest():void {
			var testCase:Object = new Object();
			var sequence:SequenceRunnerMock = new SequenceRunnerMock();
			var testFunction:Function = new Function();
			
			//Create an AsyncHandlingStatementMock and register it to to the AsyncLocator
			var asyncHandlingStatementMock:AsyncHandlingStatementMock = new AsyncHandlingStatementMock();
			AsyncLocator.registerStatementForTest(asyncHandlingStatementMock, testCase);
			
			//Set expectations
			asyncHandlingStatementMock.mock.method("asyncHandler").withArgs( asyncHandlingStatementMock.handleNextSequence, timeout, sequence, timeoutHandler).once.returns(testFunction);
			target.mock.method("addzEventListener").withArgs(eventName, testFunction, false, 0, true).once;
			
			sequenceWaiter.setupListeners(testCase, sequence);
			
			//Verify expectations were met
			asyncHandlingStatementMock.mock.verify();
			target.mock.verify();
			
			//Remove the reference from the AsyncLocator for the testCase
			AsyncLocator.cleanUpCallableForTest(testCase);
		}
	}
}