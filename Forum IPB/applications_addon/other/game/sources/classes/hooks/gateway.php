<?php
class game_hookGateway
{
	protected $registry;
	protected $DB;
	protected $settings;
	protected $request;
	protected $lang;
	protected $member;
	protected $memberData;
	protected $cache;
	protected $caches;
	
	function __construct( ipsRegistry $registry )
	{
	    /* Make registry objects */
		$this->registry		=  $registry;
		$this->DB			=  $this->registry->DB();
		$this->settings		=& $this->registry->fetchSettings();
		$this->request		=& $this->registry->fetchRequest();
		$this->lang			=  $this->registry->getClass('class_localization');
		$this->member		=  $this->registry->member();
		$this->memberData	=& $this->registry->member()->fetchMemberData();
		$this->cache		=  $this->registry->cache();
		$this->caches		=& $this->registry->cache()->fetchCaches();
	}

    public function out()
    {
		$this->DB->query("SELECT i.*, g.type, IFNULL(g.name, 'Brak') as name FROM `mini_info` i LEFT JOIN `mini_game` g ON g.uid = i.map");
		if($this->DB->getTotalRows())
		{
			$r = $this->DB->fetch();
			$r['waited'] = $r['online'] - $r['played'];
			
			$this->DB->query("SELECT p.guid, p.name, t.value FROM `mini_top` t JOIN `mini_players` p WHERE p.uid = t.player AND t.gameuid = '".$r['map']."' ORDER BY t.time ASC");
			if($this->DB->getTotalRows())
			{
				$t = $this->DB->fetch();
				if($r['type'] == 5) // race
				{
					$round = round($t['value']);
					$min = floor(($round - floor($round / 3600) * 3600) / 60);
					$sec = $round % 60;
					$number_array = explode('.', $t['value']);
					$reszta = $number_array[1];
					$r['value'] = sprintf('%02d:%02d:%s', $min, $sec, $reszta);
				}
				else $r['value'] = $t['value'].' pkt';
				if($t['guid'] != -1)
					$r['member'] = IPSMember::load( $t['guid'] );
				$r['pname'] = $t['name'];
			}
			$r['off'] = false;
			
			$this->DB->query("SELECT `value`, `time` FROM `mini_top_players` WHERE `date` = CURDATE()");
			$t = $this->DB->fetch();
			$r['v'] = $t['value'];
			$r['t'] = $t['time'];
		}
		else $r['off'] = true;
		return $this->registry->output->getTemplate('boards')->hookMiniMission($r);
    }
 }
 