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
package org.flexunit.internals.runners.model.cases
{
	import org.flexunit.Assert;
	import org.flexunit.internals.runners.model.EachTestNotifier;
	import org.flexunit.internals.runners.model.MultipleFailureException;
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.mocks.DescriptionMock;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.mocks.RunNotifierMock;

	public class EachTestNotifierCase
	{
		//TODO: Ensure that these tests and this test case are being implemented correctly
		
		protected var eachTestNotifier:EachTestNotifier;
		protected var descriptionMock:DescriptionMock;
		protected var runNotifierMock:RunNotifierMock;
		
		[Before(description="Create a new instance of the EachTestNotifier class")]
		public function createEachTestNotifier():void {
			descriptionMock = new DescriptionMock();
			runNotifierMock = new RunNotifierMock();
			
			eachTestNotifier = new EachTestNotifier(runNotifierMock, descriptionMock);
		}
		
		[After(description="Remove the reference to the EachTestNotifier class")]
		public function destroyEachTestNotifier():void {
			eachTestNotifier = null;
			descriptionMock = null;
			runNotifierMock = null;
		}
		
		[Test(description="Ensure the notifier fires a single test failure if one error is passed")]
		public function addFailureSingleErrorTest():void {
			runNotifierMock.mock.method("fireTestFailure").withArgs(Failure).once;
			
			eachTestNotifier.addFailure(new Error());
			
			runNotifierMock.mock.verify();
		}
		
		[Test(description="Ensure the notifier fires multiple times if a MultipleFailureException is passed")]
		public function addFailureMultipleErrorTest():void {
			//Adding two errors should cause addFailure to be called once for each error
			var errors:Array = new Array( new Error(), new Error() );
			var multipleFailureException:MultipleFailureException = new MultipleFailureException(errors);
			
			runNotifierMock.mock.method("fireTestFailure").twice.withArgs(Failure);
			
			eachTestNotifier.addFailure(multipleFailureException);
				
			runNotifierMock.mock.verify();
		}
		
		[Test(description="Ensure the notifier fires a single test assumption if one error is passed")]
		public function addFailedAssumptionTest():void {
			runNotifierMock.mock.method("fireTestAssumptionFailed").once.withArgs(Failure);
			
			eachTestNotifier.addFailedAssumption(new Error());
			
			runNotifierMock.mock.verify();
		}
		
		[Test(description="Ensure the notifier fires a single test finished if one error is passed")]
		public function fireTestFinishedTest():void {
			runNotifierMock.mock.method("fireTestFinished").once.withArgs(IDescription);
			
			eachTestNotifier.fireTestFinished();
			
			runNotifierMock.mock.verify();
		}
		
		[Test(description="Ensure the notifier fires a single test started if one error is passed")]
		public function fireTestStartedTest():void {
			runNotifierMock.mock.method("fireTestStarted").once.withArgs(IDescription);
			
			eachTestNotifier.fireTestStarted();
			
			runNotifierMock.mock.verify();
		}
		
		[Test(description="Ensure the notifier fires a single test ignored if one error is passed")]
		public function fireTestIgnoredTest():void {
			runNotifierMock.mock.method("fireTestIgnored").once.withArgs(IDescription);
			
			eachTestNotifier.fireTestIgnored();
			
			runNotifierMock.mock.verify();
		}
	}
}