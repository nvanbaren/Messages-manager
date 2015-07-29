--------------------------------------------------------
--  File created - zondag-juli-12-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table MESSAGES
--------------------------------------------------------

  CREATE TABLE "MESSAGES" ("ID" NUMBER(8,0), "NAME" VARCHAR2(255 BYTE), "TEXT" VARCHAR2(4000 BYTE), "LANGUAGE_CODE" VARCHAR2(5 BYTE), "CUSTOM" VARCHAR2(1 BYTE) DEFAULT 'N', "SHORTCUT" VARCHAR2(1 BYTE) DEFAULT 'N', "JAVASCRIPT" VARCHAR2(1 BYTE) DEFAULT 'N') 

   COMMENT ON COLUMN "MESSAGES"."ID" IS 'Unique identification number'
   COMMENT ON COLUMN "MESSAGES"."NAME" IS 'Name of the message'
   COMMENT ON COLUMN "MESSAGES"."TEXT" IS 'The translated message text'
   COMMENT ON COLUMN "MESSAGES"."LANGUAGE_CODE" IS 'The language of the message text.'
   COMMENT ON COLUMN "MESSAGES"."CUSTOM" IS 'The message is custom when defined by a developer and by the apex builder.'
   COMMENT ON COLUMN "MESSAGES"."SHORTCUT" IS 'The message is used in a shortcut.'
   COMMENT ON COLUMN "MESSAGES"."JAVASCRIPT" IS 'The message is used as value of a javascript variable.'
   COMMENT ON TABLE "MESSAGES"  IS 'Translatable messages as used in apex applications.'
--------------------------------------------------------
--  DDL for Index MET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "MET_PK" ON "MESSAGES" ("ID")
--------------------------------------------------------
--  DDL for Index MES_UK
--------------------------------------------------------

  CREATE UNIQUE INDEX "MES_UK" ON "MESSAGES" ("NAME", "LANGUAGE_CODE")
--------------------------------------------------------
--  Constraints for Table MESSAGES
--------------------------------------------------------

  ALTER TABLE "MESSAGES" MODIFY ("JAVASCRIPT" NOT NULL ENABLE)
  ALTER TABLE "MESSAGES" MODIFY ("SHORTCUT" NOT NULL ENABLE)
  ALTER TABLE "MESSAGES" MODIFY ("CUSTOM" NOT NULL ENABLE)
  ALTER TABLE "MESSAGES" ADD CONSTRAINT "MES_JAVASCRIPT" CHECK (javascript in ('Y','N')) ENABLE
  ALTER TABLE "MESSAGES" MODIFY ("LANGUAGE_CODE" NOT NULL ENABLE)
  ALTER TABLE "MESSAGES" ADD CONSTRAINT "MES_SHORTCUT" CHECK (shortcut in ('Y','N')) ENABLE
  ALTER TABLE "MESSAGES" ADD CONSTRAINT "MES_CUSTOM" CHECK (custom in ('Y','N')) ENABLE
  ALTER TABLE "MESSAGES" ADD CONSTRAINT "MESSAGE_ID_PK" PRIMARY KEY ("ID") ENABLE
  ALTER TABLE "MESSAGES" ADD CONSTRAINT "MES_UK" UNIQUE ("NAME", "LANGUAGE_CODE") ENABLE
  ALTER TABLE "MESSAGES" MODIFY ("TEXT" NOT NULL ENABLE)
  ALTER TABLE "MESSAGES" MODIFY ("NAME" NOT NULL ENABLE)
  ALTER TABLE "MESSAGES" MODIFY ("ID" NOT NULL ENABLE)
--------------------------------------------------------
--  Ref Constraints for Table MESSAGES
--------------------------------------------------------

  ALTER TABLE "MESSAGES" ADD CONSTRAINT "MES_LAN_FK" FOREIGN KEY ("LANGUAGE_CODE") REFERENCES "LANGUAGES" ("CODE") ENABLE
--------------------------------------------------------
--  DDL for Trigger BIR_MET_PK
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "BIR_MET_PK" 
   before insert on "MESSAGES" 
   for each row 
begin  
   if inserting then 
      if :NEW."ID" is null then 
         select MET_SEQ1.nextval into :NEW."ID" from dual; 
      end if; 
   end if; 
end;

ALTER TRIGGER "BIR_MET_PK" ENABLE
