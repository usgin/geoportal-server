-- See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- Esri Inc. licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
-- 
--      http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

DEFINE GEOPORTALUSER= '&1'
DEFINE GEOPORTALPWD = '&2'

CONNECT &GEOPORTALUSER/&GEOPORTALPWD;


-- User table -------------------------------------------------------------------

DROP TABLE GPT_USER; 
CREATE TABLE GPT_USER ( 
  USERID NUMBER(32) NOT NULL,
  DN VARCHAR2(900),
  USERNAME VARCHAR2(64),
  CONSTRAINT GPT_USER_PK PRIMARY KEY (USERID)
);

CREATE INDEX GPT_USER_IDX1 ON GPT_USER(DN);
CREATE INDEX GPT_USER_IDX2 ON GPT_USER(USERNAME);

DROP SEQUENCE GPT_USER_SEQ;
CREATE SEQUENCE GPT_USER_SEQ START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER GPT_USER_TRG BEFORE INSERT ON GPT_USER
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
  SELECT GPT_USER_SEQ.NEXTVAL INTO :NEW.USERID FROM SYS.DUAL;
END;
/

-- Saved search table ----------------------------------------------------------

DROP TABLE GPT_SEARCH;
CREATE TABLE GPT_SEARCH (
  UUID VARCHAR2(38) NOT NULL,
  NAME VARCHAR2 (255),
  USERID NUMBER(32),
  CRITERIA CLOB,
  CONSTRAINT GPT_SEARCH_PK PRIMARY KEY (UUID)
);

CREATE INDEX GPT_SEARCH_IDX1 ON GPT_SEARCH(USERID);

-- Create Harvesting table -----------------------------------------------------

DROP TABLE GPT_HARVESTING_HISTORY;
DROP TABLE GPT_HARVESTING_JOBS_PENDING;
DROP TABLE GPT_HARVESTING_JOBS_COMPLETED;

-- Create Harvesting Jobs table ------------------------------------------------

CREATE TABLE GPT_HARVESTING_JOBS_PENDING (
  UUID VARCHAR2 (38) NOT NULL,
  HARVEST_ID VARCHAR2 (38) NOT NULL,
  INPUT_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
  HARVEST_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
  JOB_STATUS VARCHAR2 (10),
  JOB_TYPE VARCHAR2 (10),
  CRITERIA VARCHAR2(1024) NULL,
  SERVICE_ID VARCHAR2 (128),
  CONSTRAINT GPT_HARVJOBSPNDG_PK PRIMARY KEY (HARVEST_ID)
);

CREATE INDEX GPT_HJOBSPNDG_IDX1 ON GPT_HARVESTING_JOBS_PENDING(UUID);
CREATE INDEX GPT_HJOBSPNDG_IDX2 ON GPT_HARVESTING_JOBS_PENDING(HARVEST_DATE);
CREATE INDEX GPT_HJOBSPNDG_IDX3 ON GPT_HARVESTING_JOBS_PENDING(INPUT_DATE);

CREATE TABLE GPT_HARVESTING_JOBS_COMPLETED (
  UUID VARCHAR2 (38) NOT NULL,
  HARVEST_ID VARCHAR2 (38) NOT NULL,
  INPUT_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
  HARVEST_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
  JOB_TYPE VARCHAR2 (10),
  SERVICE_ID VARCHAR2 (128),
  CONSTRAINT GPT_HARVJOBSCMPLTD_PK PRIMARY KEY (UUID)
);

CREATE INDEX GPT_HJOBSCMPLTD_IDX1 ON GPT_HARVESTING_JOBS_COMPLETED(HARVEST_ID);

-- Create Harvesting History table ---------------------------------------------

CREATE TABLE GPT_HARVESTING_HISTORY (
  UUID VARCHAR2 (38) NOT NULL,
  HARVEST_ID VARCHAR2 (38) NOT NULL,
  HARVEST_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
  HARVESTED_COUNT NUMBER DEFAULT 0,
  VALIDATED_COUNT NUMBER DEFAULT 0,
  PUBLISHED_COUNT NUMBER DEFAULT 0,
  HARVEST_REPORT CLOB,
  CONSTRAINT GPT_HARVHIST_PK PRIMARY KEY (UUID)
);

-- Create Resources table ----------------------------------------------------------

CREATE TABLE GPT_RESOURCE (  
  DOCUUID VARCHAR2(38) NOT NULL,
  TITLE VARCHAR2(4000),
  OWNER NUMBER NOT NULL,
  INPUTDATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UPDATEDATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ID NUMBER(32) UNIQUE NOT NULL,
  APPROVALSTATUS VARCHAR2(64),
  PUBMETHOD VARCHAR2(64),
  SITEUUID VARCHAR2(38),
  SOURCEURI VARCHAR2(4000),
  FILEIDENTIFIER VARCHAR2(4000),
  ACL VARCHAR2(4000),
  HOST_URL VARCHAR2(255), 
  PROTOCOL_TYPE VARCHAR2(20), 
  PROTOCOL VARCHAR2(1000),
  FREQUENCY VARCHAR2(10),
  SEND_NOTIFICATION   VARCHAR2(10),
  FINDABLE            VARCHAR2(6),
  SEARCHABLE          VARCHAR2(6),
  SYNCHRONIZABLE      VARCHAR2(6),
  LASTSYNCDATE        TIMESTAMP,
  CONSTRAINT GPT_RESOURCE_PK PRIMARY KEY (DOCUUID)
);

CREATE INDEX GPT_RESOURCE_IDX1  ON GPT_RESOURCE(SITEUUID);
CREATE INDEX GPT_RESOURCE_IDX2  ON GPT_RESOURCE(FILEIDENTIFIER);
CREATE INDEX GPT_RESOURCE_IDX3  ON GPT_RESOURCE(SOURCEURI);
CREATE INDEX GPT_RESOURCE_IDX4  ON GPT_RESOURCE(UPDATEDATE);
CREATE INDEX GPT_RESOURCE_IDX5  ON GPT_RESOURCE(TITLE);
CREATE INDEX GPT_RESOURCE_IDX6  ON GPT_RESOURCE(OWNER);
CREATE INDEX GPT_RESOURCE_IDX8  ON GPT_RESOURCE(APPROVALSTATUS);
CREATE INDEX GPT_RESOURCE_IDX9  ON GPT_RESOURCE(PUBMETHOD);
CREATE INDEX GPT_RESOURCE_IDX11 ON GPT_RESOURCE(ACL);
CREATE INDEX GPT_RESOURCE_IDX12 ON GPT_RESOURCE(PROTOCOL_TYPE);
CREATE INDEX GPT_RESOURCE_IDX13 ON GPT_RESOURCE(LASTSYNCDATE);

CREATE SEQUENCE GPT_RESOURCE_SEQ START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER GPT_RESOURCE_SEQ BEFORE INSERT ON GPT_RESOURCE
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
  SELECT GPT_RESOURCE_SEQ.NEXTVAL INTO :NEW.ID FROM SYS.DUAL;
END;
/

CREATE TABLE GPT_RESOURCE_DATA (
  DOCUUID    VARCHAR2(38) NOT NULL,
  ID         NUMBER(32) UNIQUE NOT NULL,
  XML        CLOB,
  THUMBNAIL  BLOB,
  CONSTRAINT GPT_RESOURCE_DATA_PK PRIMARY KEY (DOCUUID)
);

CREATE INDEX GPT_RESOURCE_DATA_IDX1  ON GPT_RESOURCE_DATA(ID);

QUIT;