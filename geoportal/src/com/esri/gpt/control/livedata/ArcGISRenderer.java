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
 * ARCGIS Renderer.
 */
/*packge*/ abstract class ArcGISRenderer extends MapBasedRenderer {

  protected abstract String getUrl();

  protected abstract boolean isImageService();

  @Override
  protected String newLayerDeclaration() {
    if (isImageService()) {
      return "new esri.layers.ArcGISImageServiceLayer(\"" +getUrl()+ "\")";
    } else {
      return "new esri.layers.ArcGISDynamicMapServiceLayer(\"" +getUrl()+ "\")";
    }
  }

  @Override
  protected boolean generateBaseMap() {
    return false;
  }

  @Override
  protected List<String> getTemplateNames() {
    if (!isImageService()) {
      return Arrays.asList(new String[]{"dynamicmap.template"});
    } else {
      return Arrays.asList(new String[]{"imagemap.template"});
    }
  }

  @Override
  protected Map<String, String> getTemplateAttributes() {
    Map<String, String> attrs = super.getTemplateAttributes();
    attrs.put("url", getUrl());
    return attrs;
  }

  @Override
  public String toString() {
    return ArcGISRenderer.class.getSimpleName() + "("+getUrl()+")";
  }
}
