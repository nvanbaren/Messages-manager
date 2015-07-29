--------------------------------------------------------
--  File created - zondag-juli-12-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table LANGUAGES
--------------------------------------------------------

  CREATE TABLE "LANGUAGES" 
   (	"NAME" VARCHAR2(50 BYTE), 
	"CODE" VARCHAR2(5 BYTE)
   )
--------------------------------------------------------
--  DDL for Index LANGUAGE_COUNTRY_CODE
--------------------------------------------------------

  CREATE UNIQUE INDEX "LANGUAGE_COUNTRY_CODE" ON "LANGUAGES" ("CODE")
--------------------------------------------------------
--  Constraints for Table LANGUAGES
--------------------------------------------------------

  ALTER TABLE "LANGUAGES" MODIFY ("CODE" NOT NULL ENABLE)
  ALTER TABLE "LANGUAGES" MODIFY ("NAME" NOT NULL ENABLE)
  ALTER TABLE "LANGUAGES" ADD CONSTRAINT "LANGUAGE_CODE_PK" PRIMARY KEY ("CODE") ENABLE
