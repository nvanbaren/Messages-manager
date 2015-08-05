--------------------------------------------------------
--  File created - zondag-juli-12-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body DO_TRANSLATIONS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "DO_TRANSLATIONS" AS

  c_dll varchar2(100) := 'alter session set current_schema="APEX_040200"';

  procedure add_messages (p_application_id    in number
                         ,p_language          in varchar2
                         ,p_workspace         in varchar2
                         ,p_include_custom    in varchar2 default 'Y'
                         ,p_include_shortcut  in varchar2 default 'Y'
                         )
  is
  
    cursor c_met(b_language varchar2
                ,b_application_id number
                )
    is
      select mes.name
      ,      mes.text
      from   messages mes
      where  mes.language_code = b_language
      and not exists (select ''
                      from   wwv_flow_messages$ mes1
                      where  mes1.flow_id = b_application_id
                      and    mes1.name = mes.name
                     )
    ;
  begin
    execute immediate c_dll;
    wwv_flow_api.set_security_group_id(apex_util.find_security_group_id(p_workspace));
    
    for r_met in c_met(p_language,p_application_id)
    loop
      wwv_flow_api.create_message (
        p_flow_id => p_application_id,
        p_name => r_met.name,
        p_message_language => p_language,
        p_message_text => r_met.text
      );
    end loop;
    commit;
  end add_messages;
  
  procedure add_shortcuts(p_application_id in number
                         ,p_workspace      in varchar2
                         )
  is
    cursor c_mes(b_application_id in number)
    is
      select mes.name
      ,      decode(mes.javascript,'Y','MESSAGE_ESCAPE_JS','MESSAGE') shortcut_type
      from   messages mes
      where  mes.shortcut = 'Y'
      and    not exists (select ''
                         from   wwv_flow_shortcuts sho
                         where  sho.shortcut_name = mes.name
                         and    sho.id = b_application_id
                        )
     ;                   
  begin
    execute immediate c_dll;
    wwv_flow_api.set_security_group_id(apex_util.find_security_group_id(p_workspace));
    for r_mes in c_mes(p_application_id)
    loop
      wwv_flow_api.create_shortcut (
        p_flow_id=> p_application_id,
        p_shortcut_name=> r_mes.name,
        p_shortcut_type=> r_mes.shortcut_type
      );
    end loop;
    commit;
  end add_shortcuts;
  
  function add_messages (p_application_id    in number
                        ,p_language          in varchar2
                        ,p_include_custom    in varchar2 default 'Y'
                        ,p_include_shortcut  in varchar2 default 'Y'
                        )
  return varchar2
  is
    cursor c_mes(b_application_id    in number
                ,b_language          in varchar2
                ,b_include_custom    in varchar2
                ,b_include_shortcut  in varchar2
                )
    is
      select mes.text
      ,      mes.name
      from   messages mes
      where  not exists (select ''
                         from   apex_application_translations tra
                         where  tra.application_id = b_application_id
                         and    tra.translatable_message = mes.name
                         and    tra.language_code = mes.language_code
                        )
      and    mes.language_code = b_language
      and    (
              mes.custom = b_include_custom
              or
              b_include_custom = 'Y'
             )
      and    (
              mes.shortcut = b_include_shortcut
              or
              b_include_shortcut = 'Y'
             )       
    ;
    i number :=0;
    v_melding varchar2(32767);
  begin
    apex_debug.message('Start add_messages');
    apex_debug.message('Parameters  1 '||p_application_id||', 2 '||p_language||', 3 '||p_include_custom||', 4 '||p_include_shortcut);
    for r_mes in c_mes(p_application_id,p_language,p_include_custom, p_include_shortcut)
    loop
      i := i+1;
      wwv_flow_api.create_message (
        p_flow_id => p_application_id,
        p_name => r_mes.name,
        p_message_language => p_language,
        p_message_text => r_mes.text
      );
    end loop;
    v_melding := case i
                   when 0 
                   then
                     apex_lang.message('NO_INSERT','messages')
                   when 1
                   then
                     apex_lang.message('1_INSERT','message')
                 else
                   apex_lang.message('MULTIPLE_INSERT','messages',i)
                 end;             
    apex_debug.message('End add_messages');             
    return v_melding;
  end add_messages;
  
  function add_shortcuts(p_application_id in number)
  return varchar2
  is
    cursor c_mes(b_application_id in number)
    is
      select mes.name
      ,      decode(mes.javascript,'Y','MESSAGE_ESCAPE_JS','MESSAGE') shortcut_type
      from   messages mes
      where  mes.shortcut = 'Y'
      and    not exists (select ''
                         from   apex_application_shortcuts sho
                         where  sho.shortcut_name = mes.name
                         and    sho.application_id = b_application_id
                        )
    ;
    i           number := 0;
    v_melding   varchar2(32767);
  begin
    for r_mes in c_mes(p_application_id)
    loop
      i := i + 1;
      wwv_flow_api.create_shortcut (
        p_flow_id=> p_application_id,
        p_shortcut_name=> r_mes.name,
        p_shortcut_type=> r_mes.shortcut_type
      );
    end loop;
    v_melding := case i
                   when 0 
                   then
                     apex_lang.message('NO_INSERT','shortcuts')
                   when 1
                   then
                     apex_lang.message('1_INSERT','shortcut')
                 else
                   apex_lang.message('MULTIPLE_INSERT','shortcuts',i)
                 end; 
    return v_melding;
  end add_shortcuts;
  
  function update_messages (
    p_application_id    in number,
    p_language          in varchar2,
    p_include_custom    in varchar2 default 'Y',
    p_include_shortcut  in varchar2 default 'Y'
  )
  return varchar2
  is
    cursor c_mes (
      b_application_id in number,
      b_language       in varchar2,
      b_include_custom in varchar2,
      b_include_shortcut in varchar2
    ) is
      select mes.text
      ,      mes.name
      from   messages mes
      where  exists (select ''
                     from   apex_application_translations tra
                     where  tra.application_id = b_application_id
                     and    tra.translatable_message = mes.name
                     and    tra.language_code = mes.language_code
                     and    tra.message_text != mes.text
                    )
      and    mes.language_code = b_language
      and    (
              mes.custom = b_include_custom
              or
              b_include_custom = 'Y'
             )
      and    (
              mes.shortcut = b_include_shortcut
              or
              b_include_shortcut = 'Y'
             )       
    ;
    i number := 0;
    v_melding varchar2(32767);
  begin
    for r_mes in c_mes(p_application_id,p_language,p_include_custom, p_include_shortcut)
    loop
      i := i+1;
      update wwv_flow_messages$ mes
      set    mes.message_text = r_mes.text
      where  mes.name = r_mes.name
      ;
    end loop;
    v_melding := case i
                   when 0 
                   then
                     apex_lang.message('NO_UPDATE','messages')
                   when 1
                   then
                     apex_lang.message('1_UPDATE','message')
                 else
                   apex_lang.message('MULTIPLE_UPDATE','messages',i)
                 end; 
    return v_melding;
  end update_messages;
  
  function update_shortcuts(p_application_id in number)
  return varchar2
  is
    cursor c_mes(b_application_id in number)
    is
      select mes.name
      ,      decode(mes.javascript,'Y','MESSAGE_ESCAPE_JS','MESSAGE') shortcut_type
      from   messages mes
      where  mes.shortcut = 'Y'
      and    not exists (select ''
                         from   apex_application_shortcuts sho
                         where  sho.shortcut_name = mes.name
                         and    sho.application_id = b_application_id
                         and    sho.shortcut_type != decode(mes.javascript,
                                                            'Y','MESSAGE_ESCAPE_JS',
                                                            'MESSAGE'
                                                           )
                        )
    ;
    i           number := 0;
    v_melding   varchar2(32767);
  begin
    for r_mes in c_mes(p_application_id)
    loop
      i := i + 1;
      update wwv_flow_shortcuts sho
      set    sho.shortcut_type = r_mes.shortcut_type
      where  sho.shortcut_name = r_mes.name
      ;
    end loop;
    v_melding := case i
                   when 0 
                   then
                     apex_lang.message('NO_UPDATE','shortcuts')
                   when 1
                   then
                     apex_lang.message('1_UPDATE','shortcut')
                 else
                   apex_lang.message('MULTIPLE_UPDATE','shortcuts',i)
                 end; 
    return v_melding;
  end update_shortcuts;
  
end do_translations;
