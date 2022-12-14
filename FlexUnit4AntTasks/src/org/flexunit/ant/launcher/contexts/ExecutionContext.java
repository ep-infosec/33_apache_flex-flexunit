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
package org.flexunit.ant.launcher.contexts;

import java.io.IOException;

import org.apache.tools.ant.Project;
import org.flexunit.ant.launcher.commands.player.PlayerCommand;

/**
 * Basis for executing a player command.
 */
public interface ExecutionContext
{
   public void setProject(Project project);
   public void setCommand(PlayerCommand command);
   
   /**
    * Starts the execution context and any work associated with the individual implementations.
    * 
    * @throws IOException
    */
   public void start() throws IOException;
   
   /**
    * Stops the execution context and manages the player Process as well as any work associated
    * with the individual implementations.
    * 
    * @param playerProcess
    * @throws IOException
    */
   public void stop(Process playerProcess) throws IOException;
}
