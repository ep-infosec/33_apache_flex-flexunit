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
package org.flexunit.events.cases
{
	import flash.events.Event;
	
	import org.flexunit.Assert;
	import org.flexunit.events.AsyncEvent;

	public class AsyncEventCase
	{
		//TODO: Verify this test case is being handled correctly
		
		protected var asyncEvent:AsyncEvent;
		
		protected var originalEvent:Event;
		
		[Before(description="Creates an AsyncEvent")]
		public function createAsyncResponseEvent():void {
			originalEvent = new Event("originalEvent")
			
			asyncEvent = new AsyncEvent("async", false, false, originalEvent);
		}
		
		[After(description="Destroy the reference to the AsyncEvent")]
		public function destroyAsyncEvent():void {
			originalEvent = null;
			asyncEvent = null;
		}
		
		[Test(description="Ensure the AsyncEvent is successfully created")]
		public function createAsyncEventTest():void {
			Assert.assertEquals(originalEvent, asyncEvent.originalEvent);
		}
		
		[Test(description="Ensure the AsyncEvent is successfully cloned")]
		public function cloneAsyncEventTest():void {
			var newAsyncEvent:AsyncEvent = asyncEvent.clone() as AsyncEvent;
			
			Assert.assertEquals(originalEvent, newAsyncEvent.originalEvent);
		}
	}
}