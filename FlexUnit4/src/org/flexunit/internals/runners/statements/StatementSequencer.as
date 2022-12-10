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
package org.flexunit.internals.runners.statements {
	import flash.utils.*;
	
	import org.flexunit.internals.runners.model.MultipleFailureException;
	import org.flexunit.runner.notification.StoppedByUserException;
	import org.flexunit.token.AsyncTestToken;
	import org.flexunit.token.ChildResult;
	import org.flexunit.utils.ClassNameUtil;
	
	/**
	 * The <code>StatementSequencer</code> is a class that is responsible for the execution of
	 * <code>IAsyncStatement</code>s.  These statements can be provided to the <code>StatementSequencer</code>
	 * as an array during instantiation or added using the <code>#addStep</code> method.<br/>
	 * 
	 * The list of statements can be executed using the <code>#evaluate</code> method and any errors encountered
	 * during execution will be noted and reported.  Each statement will be run in sequence, meaning the next will not
	 * start to be executed until the current statement has finished.
	 */
	public class StatementSequencer extends AsyncStatementBase implements IAsyncStatement {
		/**
		 * An array of queued statements to run.
		 */
		protected var queue:Array;
		/**
		 * An array of errors that have been encountered during the execution of statements.
		 */
		protected var errors:Array;
		
		/**
		 * Constructor.
		 * 
		 * @param queue An array containing objects that implement <code>IAsyncStatment</code> that are to be
		 * evaluated by the sequencer.
		 */
		public function StatementSequencer( queue:Array=null ) {
			super();
			
			if (!queue) {
				queue = new Array();
			}			
			
			//Copy the queue
			this.queue = queue.slice();
			this.errors = new Array();		
			
			//Create a new token that will alert this class when the provided statement has completed
			myToken = new AsyncTestToken( ClassNameUtil.getLoggerFriendlyClassName( this ) );
			myToken.addNotificationMethod( handleChildExecuteComplete );
		}
		
		/**
		 * Adds a <code>child</code> that implements <code>IAsyncStatement</code> to the end of the queue of 
		 * statments to execute by the sequencer.
		 * 
		 * @param child The object that implements <code>IAsyncStatement</code> to add.
		 */
		public function addStep( child:IAsyncStatement ):void {
			if ( child ) {
				queue.push( child );
			}
		}
		
		/**
		 * Evaluates the provided <code>child</code> if the <code>child</code> is an 
		 * <code>IAsyncStatement</code>.
		 * 
		 * @param child The child object to be evaluated.
		 */
		protected function executeStep( child:* ):void {
			if ( child is IAsyncStatement ) {
				IAsyncStatement( child ).evaluate( myToken );
			}
		}
		
		/**
		 * Starts evaluating the queue of statements that was provided to the sequencer.
		 * 
		 * @param parentToken The token to be notified when all statements have finished running.
		 */
		public function evaluate( parentToken:AsyncTestToken ):void {
			this.parentToken = parentToken;
			handleChildExecuteComplete( null );
		}
		
		/**
		 * Determine if any errors were encountered for a potential statement that has just run and returned the
		 * provided <code>result</code>.  If an error was encountered during the last statement, add that error to
		 * a list of errors encountered in every statement in the sequencer.<br/>
		 * 
		 * If there are still statements that need to be evaluated, execute the first unexecuted step in the sequence.
		 * Otherwise, if all statements have finished running, the <code>StatementSequencer</code> has finished and will
		 * report any errors that have been encoutnred.
		 * 
		 * @param result A potential <code>ChildResult</code> that was encountered during the execution of the
		 * previous statement.
		 */
		public function handleChildExecuteComplete( result:ChildResult ):void {
			var step:*;
			
			if ( result && result.error ) {
				errors.push( result.error );
				
				if ( result.error is StoppedByUserException ) {
					sendComplete();
					return;
				}
				
			}
			
			if ( queue.length > 0 ) {
				step = queue.shift();	
				
				//trace("Sequence Executing Next Step " + step  );
				executeStep( step );
				//trace("Sequence Done Executing Step " + step );
			} else {
				//trace("Sequence Sending Complete " + this );
				sendComplete(); 
			}
		}

		/**
		 * If an <code>error</code> is provided, it will be added to the list of errors encountered during the execution
		 * of the statements.  If the error list contains more than one error, a <code>MultipleFailureException</code>
		 * will be created an given the corresponding errors.  The parentToken will then be notified of any error
		 * encountered during execution of the statements.
		 * 
		 * @inheritDoc
		 */
		override protected function sendComplete( error:Error=null ):void {
			var sendError:Error;
			
			//Determine if any errors were passed to this method
			if ( error ) {
				errors.push( error );
			}
			
			//Determine whether to send a single error or MultipleFailureException containing the array of errors
			if (errors.length == 1)
				sendError = errors[ 0 ];
			else if ( errors.length > 1 ) {
				sendError = new MultipleFailureException(errors);
			}

			super.sendComplete( sendError );
		}

		/**
		 * Returns the current queue of statements that are in the sequence. 
		 * 
		 * @return a string representing the sequence queue.
		 */
		override public function toString():String {
			var sequenceString:String = "StatementSequencer :\n";
			
			if ( queue ) {
				for ( var i:int=0; i<queue.length; i++ ) {
					sequenceString += ( "   " + i + " : " + queue[ i ].toString() + "\n" );
				}
			}
			
			return sequenceString;
		}
	}
}