/* See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * Esri Inc. licenses this file to You under the Apache License, Version 2.0
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
package com.esri.gpt.control.livedata;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Simple link renderer.
 */
/*package*/ abstract class LinkRenderer extends TemplateBasedRenderer {

  /**
   * Gets service URL.
   * @return service URL
   */
  protected abstract String getUrl();

  @Override
  protected Map<String, String> getTemplateAttributes() {
    HashMap<String,String> attrs = new HashMap<String, String>();
    attrs.put("url", getUrl());
    return attrs;
  }

  @Override
  protected List<String> getTemplateNames() {
    return Arrays.asList(new String[]{"link.template"});
  }

  @Override
  public String toString() {
    return LinkRenderer.class.getSimpleName() + "("+getUrl()+")";
  }

}
