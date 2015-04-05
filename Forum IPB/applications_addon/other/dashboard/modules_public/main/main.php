<?php

class public_dashboard_main_main extends ipsCommand
{
	public function doExecute( ipsRegistry $registry ) 
	{
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'public_dashboard' ) );
		IPSText::getTextClass( 'bbcode' )->parse_html = 1;
		IPSText::getTextClass( 'bbcode' )->parse_bbcode = 1;
		IPSText::getTextClass( 'bbcode' )->parse_smilies = 1;
		IPSText::getTextClass( 'bbcode' )->parsing_section = 'app=dashboard&module=main';
		$news = $this->DB->query('SELECT p.*, t.*, m.members_display_name, m.member_group_id FROM '.$this->DB->obj['sql_tbl_prefix'].'posts p JOIN '.$this->DB->obj['sql_tbl_prefix'].'topics t ON p.topic_id = t.tid JOIN '.$this->DB->obj['sql_tbl_prefix'].'members m ON m.member_id = t.starter_id WHERE t.forum_id = 2 AND p.new_topic = 1 AND t.tdelete_time = 0 ORDER BY t.start_date DESC LIMIT 5');

		while( $r = $this->DB->fetch($news) )
		{
			$r['text'] = IPSText::getTextClass('bbcode')->preDisplayParse( $r['post'] );
			$newsList[] = $r;
		}
		$template = $this->registry->output->getTemplate('dashboard')->dash_main($newsList);
		ipsRegistry::getClass('output')->addContent($template);
		$this->registry->output->setTitle($this->lang->words['main_page']);
		ipsRegistry::getClass('output')->sendOutput();
	}
}
?>
