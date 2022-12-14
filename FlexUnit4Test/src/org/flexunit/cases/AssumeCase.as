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
package org.flexunit.cases
{
	import flexunit.framework.Assert;
	import flexunit.framework.AssertionFailedError;
	
	import org.flexunit.Assume;
	import org.flexunit.internals.AssumptionViolatedException;
	import org.hamcrest.object.nullValue;
	
	public class AssumeCase
	{
		[Test(description="Ensure assumeTrue succeeds when a 'true' argument is passed")] 
		public function assumeTrueTestPass():void {
			try {
				Assume.assumeTrue(true);
			} catch(e:AssumptionViolatedException) {
				throw new AssertionFailedError("Assumption Violated");
			}
		}
		
		[Test(expected="org.flexunit.internals.AssumptionViolatedException",
			description="Ensure assumeTrue fails when a 'false' argument is passed")]
		public function assumeTrueTestFail():void { 		
			Assume.assumeTrue(false);
		}
		
		[Test(description="Ensure assumneNotNull succeeds when no arguments are passed")] 
		public function assumeNotNullEmptyPass():void { 
			try {
				Assume.assumeNotNull();
			} catch(e:AssumptionViolatedException) {
				throw new AssertionFailedError("Assumption Violated");
			}
		}
		
		[Test(description="Ensure assumneNotNull succeeds when a signle non-null argument is passed")] 
		public function assumeNotNullSinglePass():void { 
			try {
				Assume.assumeNotNull(new Object());
			} catch(e:AssumptionViolatedException) {
				throw new AssertionFailedError("Assumption Violated");
			}
		}
		
		[Test(description="Ensure assumneNotNull succeeds when multiple non-null arguments are passed")] 
		public function assumeNotNullMultiplePass():void { 
			try {
				Assume.assumeNotNull(new Object(), new Object(), new Object());
			} catch(e:AssumptionViolatedException) {
				throw new AssertionFailedError("Assumption Violated");
			}
		}
		
		[Test(expected="org.flexunit.internals.AssumptionViolatedException",
			description="Ensure assumneNotNull fails for a sigle null argument")]
		public function assumeNotNullSingleFail():void { 
			Assume.assumeNotNull(null);
		}
		
		[Test(expected="org.flexunit.internals.AssumptionViolatedException",
			description="Ensure assumneNotNull fails for multiple arguments with one being a null argument")]
		public function assumeNotNullMultipleFail():void { 
			Assume.assumeNotNull(new Object(), new Object(), null, new Object());
		}
		
		[Test(description="Ensure assumeThat succeeds when the actual argument matches the matcher argument")]
		public function assumeThatTestPass():void { 
			try {
				Assume.assumeThat(null, nullValue());
			} catch(e:AssumptionViolatedException) {
				throw new AssertionFailedError("Assumption Violated");
			}
		}
		
		[Test(expected="org.flexunit.internals.AssumptionViolatedException",
			description="Ensure assumeThat fails when the actual argument does not match the matcher argument")]
		public function assumeThatTestFail():void { 
			Assume.assumeThat(new Object(), nullValue());
		}
		
		[Test(description="Ensure assumeThatNoException passes when no exception argument is passed")]
		public function assumeThatNoExceptionPass():void {
			try {
				Assume.assumeNoException(null);
			} catch(e:AssumptionViolatedException) {
				throw new AssertionFailedError("Assumption Violated");
			}
		}
		
		[Test(expected="org.flexunit.internals.AssumptionViolatedException",
			description="Ensure assumeThatNoException fails when an exception argument is passed")]
		public function assumeThatNoExceptionFail():void { 
			Assume.assumeNoException(new Error);
		}
	}
}