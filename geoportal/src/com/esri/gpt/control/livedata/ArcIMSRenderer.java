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
import java.util.List;
import java.util.Map;

/**
 * ArcIMS renderer.
 */
/*package*/abstract class ArcIMSRenderer extends MapBasedRenderer {

  protected abstract String getProxyUrl();
  protected abstract String getUrl();

  @Override
  protected List<String> getTemplateNames() {
    return Arrays.asList(new String[]{"arcimsmap.template"});
  }

  @Override
  protected Map<String, String> getTemplateAttributes() {
    Map<String, String> attrs = super.getTemplateAttributes();
    attrs.put("url", getUrl());
    attrs.put("proxy", getProxyUrl());
    return attrs;
  }

  @Override
  protected String newLayerDeclaration() {
    return "new esri.gpt.layers.ArcIMSLayer(\"" +getUrl()+ "\",\"" +getProxyUrl()+ "\",widget.getGeometryServiceUrl())";
  }

  @Override
  protected String initializeNewLayer() {
    return "var extent = " +createExtentDef()+ ";" +
           "node.liveDataMap.setExtent(extent);";
  }

  @Override
  protected String finalizeNewLayer() {
    return "dojo.connect(node.liveDataMap,\"onLoad\",null,function(map){" +
              "var extent = " +createExtentDef()+ ";" +
              "map.setExtent(extent);"+
           "});";
  };

  @Override
  protected boolean generateBaseMap() {
    return false;
  }

  @Override
  public String toString() {
    return ArcIMSRenderer.class.getSimpleName() + "("+getUrl()+")";
  }

}
