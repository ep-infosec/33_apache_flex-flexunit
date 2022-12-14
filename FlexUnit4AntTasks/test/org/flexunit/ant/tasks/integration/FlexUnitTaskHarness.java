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
package org.flexunit.ant.tasks.integration;

import java.io.File;

import junit.framework.TestCase;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.FileSet;
import org.flexunit.ant.tasks.FlexUnitTask;

public class FlexUnitTaskHarness extends TestCase
{
   private FlexUnitTask fixture;
   
   protected void setUp()
   {
      fixture = new FlexUnitTask();
      Project project = new Project();
      project.setProperty("ant.home", "/usr/share/java/ant-1.7.1");
      project.setProperty("FLEX_HOME", System.getenv("FLEX_HOME"));
      fixture.setProject(project);
      
      //call all setters for task attributes
      fixture.setHaltonfailure(true);
      fixture.setLocalTrusted(true);
      fixture.setPort(1024);
      fixture.setTimeout(10000);
      fixture.setBuffer(555555);
      //fixture.setSWF("test/TestRunner.swf");
      fixture.setToDir("test/sandbox");
      fixture.setVerbose(true);
      fixture.setFailureproperty("failedtests");
      fixture.setPlayer("flash");
      //fixture.setCommand("/Applications/Safari.app/Contents/MacOS/Safari");
      fixture.setHeadless(false);
      fixture.setWorkingDir("test/sandbox");
      
      //Call elements next
      FileSet testSourceFileSet = new FileSet();
      testSourceFileSet.setDir(new File("test/sandbox/src"));
      testSourceFileSet.setIncludes("**/*class.as");
      fixture.addTestSource(testSourceFileSet);
      
      FileSet libraryFileSet = new FileSet();
      libraryFileSet.setDir(new File("test/sandbox/libs"));
      fixture.addLibrary(libraryFileSet);
   }

   public void testExecute()
   {
      fixture.execute();
   }

}
