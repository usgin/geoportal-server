/*
 * Copyright 2013 Esri.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.esri.gpt.control.livedata;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Template file based renderer.
 */
public abstract class TemplateBasedRenderer implements IRenderer {
  private static String DEFAULT_TEMPLATE_PATH = "com/esri/gpt/control/livedata/templates";
  
  @Override
  public void render(Writer writer) throws IOException {
    try {
      String template = getTemplate();
      for (Map.Entry<String,String> e: getTemplateAttributes().entrySet()) {
        Pattern pattern = Pattern.compile("\\{@"+e.getKey()+"\\}");
        Matcher matcher = pattern.matcher(template);
        int start = 0;
        if (matcher.find(start)) {
          template = matcher.replaceAll(e.getValue());
        }
      }
      writer.write(template);
    } catch (URISyntaxException ex) {
      throw new IOException("Error reading template", ex);
    }
  }
  
  protected String getTemplate()  throws IOException, URISyntaxException {
    return readTemplate().toString();
  }
  
  protected final StringBuilder readTemplate() throws IOException, URISyntaxException {
    StringBuilder sb = new StringBuilder();
    for (String templateName: getTemplateNames()) {
      sb.append(readTemplate(templateName));
    }
    return sb;
  }
  
  protected final StringBuilder readTemplate(String templateName) throws IOException, URISyntaxException {
    URL templateURL = getTemplateURL(templateName);
    InputStream stream = null;
    Reader reader = null;
    StringBuilder sb = new StringBuilder();
    try {
      stream = templateURL.openStream();
      reader = new BufferedReader(new InputStreamReader(stream, "UTF-8"));
      
      char [] buff = new char[1024];
      int length = 0;
      
      while ((length=reader.read(buff))>0) {
        sb.append(buff, 0, length);
      }
      
      return sb;
    } finally {
      if (reader!=null) {
        reader.close();
      }
      if (stream!=null) {
        try {
          stream.close();
        } catch (IOException ex) {}
      }
    }
  }
  
  protected final URL getTemplateURL(String templateName) throws IOException, URISyntaxException {
    URL resource = Thread.currentThread().getContextClassLoader().getResource(DEFAULT_TEMPLATE_PATH);
    URI toURI = resource.toURI();
    URI resolve = toURI.resolve(templateName);
    URL toURL = resolve.toURL();
    return toURL;
  }
  
  protected abstract Map<String,String> getTemplateAttributes();
  
  protected abstract List<String> getTemplateNames();
  
}
