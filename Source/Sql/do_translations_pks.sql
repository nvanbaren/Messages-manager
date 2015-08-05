--------------------------------------------------------
--  File created - zondag-juli-12-2015   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package DO_TRANSLATIONS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "DO_TRANSLATIONS" 
as
  
  procedure add_messages (p_application_id    in number
                         ,p_language          in varchar2
                         ,p_workspace         in varchar2
                         ,p_include_custom    in varchar2 default 'Y'
                         ,p_include_shortcut  in varchar2 default 'Y'
                         );
                         
  procedure add_shortcuts(p_application_id in number
                         ,p_workspace      in varchar2
                         );
                         
  function add_messages (p_application_id    in number
                        ,p_language          in varchar2
                        ,p_include_custom    in varchar2 default 'Y'
                        ,p_include_shortcut  in varchar2 default 'Y'
                        )
  return varchar2;

  function add_shortcuts(p_application_id in number)
  return varchar2;
  
  function update_messages (
    p_application_id    in number,
    p_language          in varchar2,
    p_include_custom    in varchar2 default 'Y',
    p_include_shortcut  in varchar2 default 'Y'
  )
  return varchar2;
  
  function update_shortcuts(p_application_id in number)
  return varchar2;
  
end do_translations;
