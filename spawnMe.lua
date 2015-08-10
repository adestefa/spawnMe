--[[ 
======================================= 
    spawnMeMe v 0.9  1:43 AM 8/2/2015
======================================= 
	[What is it?]
	Possess a random nearby ped, or spawn a new host ped and take them over. Each time you spawn you will drop your warrants, make you invincible and give you weapons. Embody any of the over 250 peds found in GTA V. 


	[Controls]
	Cycle through the list of over 650 models:
	- 'J' Jump into a random nearby ped
	- 'k' to change into the last ped


	This code is free to use and share, but please give credit and use in good will. (CoreLogic http://www.developer-me.com/forums/member.php?action=profile&uid=29)
  
	Github: https://github.com/adestefa/spawnMe.git	
  
	Installation:
	 1. Install Script Hook https://www.gta5-mods.com/tools/script-hook-v 
	 2. Install the LUA script plugin for Scripthook https://www.gta5-mods.com/tools/lua-plugin-for-script-hook-v 
	 3. Download the flatsMiniGame file
	 4. Put the <b>spawnMe.lua</b> file in your <install dir>\Grand Theft Auto V\scripts\addins folder. 
	 5. Text will appear above the mini-map when installed correctly
 
 -------------------------------
 version 0.9 8/2/2015
  - base version  
]]--
local spawnMe = {};
spawnMe.settings = {};
-- Settings For you
spawnMe.settings["delete_the_dead"] = true; -- set to false to let bodies pile up, (note: will increase memory usage when false)
-- no touch...
spawnMe.data = {};
spawnMe.data["clone"] = nil; 
spawnMe.data["pointer"] = 1;
spawnMe.seenPeds = {}; -- keep track of every clone we create;
-- ======================================= --
-- skins player can clone into
-- ======================================= --
spawnMe.list = {"a_f_m_bevhills_01", "a_f_m_bevhills_02", "a_f_m_bodybuild_01", "a_f_m_business_02", "a_f_m_downtown_01", "a_f_m_eastsa_01", "a_f_m_eastsa_02", "a_f_m_fatbla_01", "a_f_m_fatcult_01",
	"a_f_m_fatwhite_01", "a_f_m_ktown_01", "a_f_m_ktown_02", "a_f_m_prolhost_01", "a_f_m_salton_01", "a_f_m_skidrow_01", "a_f_m_soucentmc_01", "a_f_m_soucent_01", "a_f_m_soucent_02", "a_f_m_tourist_01",
	"a_f_m_trampbeac_01", "a_f_m_tramp_01", "a_f_o_genstreet_01", "a_f_o_indian_01", "a_f_o_ktown_01", "a_f_o_salton_01", "a_f_o_soucent_01", "a_f_o_soucent_02", "a_f_y_beach_01", "a_f_y_bevhills_01",
	"a_f_y_bevhills_02", "a_f_y_bevhills_03", "a_f_y_bevhills_04", "a_f_y_business_01", "a_f_y_business_02", "a_f_y_business_03", "a_f_y_business_04", "a_f_y_eastsa_01", "a_f_y_eastsa_02", "a_f_y_eastsa_03",
	"a_f_y_epsilon_01", "a_f_y_fitness_01", "a_f_y_fitness_02", "a_f_y_genhot_01", "a_f_y_golfer_01", "a_f_y_hiker_01", "a_f_y_hippie_01", "a_f_y_hipster_01", "a_f_y_hipster_02", "a_f_y_hipster_03",
	"a_f_y_hipster_04", "a_f_y_indian_01", "a_f_y_juggalo_01", "a_f_y_runner_01", "a_f_y_rurmeth_01", "a_f_y_scdressy_01", "a_f_y_skater_01", "a_f_y_soucent_01", "a_f_y_soucent_02", "a_f_y_soucent_03",
	"a_f_y_tennis_01", "a_f_y_topless_01", "a_f_y_tourist_01", "a_f_y_tourist_02", "a_f_y_vinewood_01", "a_f_y_vinewood_02", "a_f_y_vinewood_03", "a_f_y_vinewood_04", "a_f_y_yoga_01", "a_m_m_acult_01",
	"a_m_m_afriamer_01", "a_m_m_beach_01", "a_m_m_beach_02", "a_m_m_bevhills_01", "a_m_m_bevhills_02", "a_m_m_business_01", "a_m_m_eastsa_01", "a_m_m_eastsa_02", "a_m_m_farmer_01", "a_m_m_fatlatin_01",
	"a_m_m_genfat_01", "a_m_m_genfat_02", "a_m_m_golfer_01", "a_m_m_hasjew_01", "a_m_m_hillbilly_01", "a_m_m_hillbilly_02", "a_m_m_indian_01", "a_m_m_ktown_01", "a_m_m_malibu_01", "a_m_m_mexcntry_01",
	"a_m_m_mexlabor_01", "a_m_m_og_boss_01", "a_m_m_paparazzi_01", "a_m_m_polynesian_01", "a_m_m_prolhost_01", "a_m_m_rurmeth_01", "a_m_m_salton_01", "a_m_m_salton_02", "a_m_m_salton_03", "a_m_m_salton_04",
	"a_m_m_skater_01", "a_m_m_skidrow_01", "a_m_m_socenlat_01", "a_m_m_soucent_01", "a_m_m_soucent_02", "a_m_m_soucent_03", "a_m_m_soucent_04", "a_m_m_stlat_02", "a_m_m_tennis_01", "a_m_m_tourist_01",
	"a_m_m_trampbeac_01", "a_m_m_tramp_01", "a_m_m_tranvest_01", "a_m_m_tranvest_02", "a_m_o_acult_01", "a_m_o_acult_02", "a_m_o_beach_01", "a_m_o_genstreet_01", "a_m_o_ktown_01", "a_m_o_salton_01",
	"a_m_o_soucent_01", "a_m_o_soucent_02", "a_m_o_soucent_03", "a_m_o_tramp_01", "a_m_y_acult_01", "a_m_y_acult_02", "a_m_y_beachvesp_01", "a_m_y_beachvesp_02", "a_m_y_beach_01", "a_m_y_beach_02",
	"a_m_y_beach_03", "a_m_y_bevhills_01", "a_m_y_bevhills_02", "a_m_y_breakdance_01", "a_m_y_busicas_01", "a_m_y_business_01", "a_m_y_business_02", "a_m_y_business_03", "a_m_y_cyclist_01", "a_m_y_dhill_01",
	"a_m_y_downtown_01", "a_m_y_eastsa_01", "a_m_y_eastsa_02", "a_m_y_epsilon_01", "a_m_y_epsilon_02", "a_m_y_gay_01", "a_m_y_gay_02", "a_m_y_genstreet_01", "a_m_y_genstreet_02", "a_m_y_golfer_01",
	"a_m_y_hasjew_01", "a_m_y_hiker_01", "a_m_y_hippy_01", "a_m_y_hipster_01", "a_m_y_hipster_02", "a_m_y_hipster_03", "a_m_y_indian_01", "a_m_y_jetski_01", "a_m_y_juggalo_01", "a_m_y_ktown_01",
	"a_m_y_ktown_02", "a_m_y_latino_01", "a_m_y_methhead_01", "a_m_y_mexthug_01", "a_m_y_motox_01", "a_m_y_motox_02", "a_m_y_musclbeac_01", "a_m_y_musclbeac_02", "a_m_y_polynesian_01", "a_m_y_roadcyc_01",
	"a_m_y_runner_01", "a_m_y_runner_02", "a_m_y_salton_01", "a_m_y_skater_01", "a_m_y_skater_02", "a_m_y_soucent_01", "a_m_y_soucent_02", "a_m_y_soucent_03", "a_m_y_soucent_04", "a_m_y_stbla_01",
	"a_m_y_stbla_02", "a_m_y_stlat_01", "a_m_y_stwhi_01", "a_m_y_stwhi_02", "a_m_y_sunbathe_01", "a_m_y_surfer_01", "a_m_y_vindouche_01", "a_m_y_vinewood_01", "a_m_y_vinewood_02", "a_m_y_vinewood_03",
	"a_m_y_vinewood_04", "a_m_y_yoga_01", "u_m_y_proldriver_01", "u_m_y_rsranger_01", "u_m_y_sbike", "u_m_y_staggrm_01", "u_m_y_tattoo_01", "csb_abigail", "csb_anita", "csb_anton",
	"csb_ballasog", "csb_bride", "csb_burgerdrug", "csb_car3guy1", "csb_car3guy2", "csb_chef", "csb_chin_goon", "csb_cletus", "csb_cop", "csb_customer",
	"csb_denise_friend", "csb_fos_rep", "csb_g", "csb_groom", "csb_grove_str_dlr", "csb_hao", "csb_hugh", "csb_imran", "csb_janitor", "csb_maude",
	"csb_mweather", "csb_ortega", "csb_oscar", "csb_porndudes", "csb_porndudes_p", "csb_prologuedriver", "csb_prolsec", "csb_ramp_gang", "csb_ramp_hic", "csb_ramp_hipster",
	"csb_ramp_marine", "csb_ramp_mex", "csb_reporter", "csb_roccopelosi", "csb_screen_writer", "csb_stripper_01", "csb_stripper_02", "csb_tonya", "csb_trafficwarden", "cs_amandatownley",
	"cs_andreas", "cs_ashley", "cs_bankman", "cs_barry", "cs_barry_p", "cs_beverly", "cs_beverly_p", "cs_brad", "cs_bradcadaver", "cs_carbuyer",
	"cs_casey", "cs_chengsr", "cs_chrisformage", "cs_clay", "cs_dale", "cs_davenorton", "cs_debra", "cs_denise", "cs_devin", "cs_dom",
	"cs_dreyfuss", "cs_drfriedlander", "cs_fabien", "cs_fbisuit_01", "cs_floyd", "cs_guadalope", "cs_gurk", "cs_hunter", "cs_janet", "cs_jewelass",
	"cs_jimmyboston", "cs_jimmydisanto", "cs_joeminuteman", "cs_johnnyklebitz", "cs_josef", "cs_josh", "cs_lamardavis", "cs_lazlow", "cs_lestercrest", "cs_lifeinvad_01",
	"cs_magenta", "cs_manuel", "cs_marnie", "cs_martinmadrazo", "cs_maryann", "cs_michelle", "cs_milton", "cs_molly", "cs_movpremf_01", "cs_movpremmale",
	"cs_mrk", "cs_mrsphillips", "cs_mrs_thornhill", "cs_natalia", "cs_nervousron", "cs_nigel", "cs_old_man1a", "cs_old_man2", "cs_omega", "cs_orleans",
	"cs_paper", "cs_paper_p", "cs_patricia", "cs_priest", "cs_prolsec_02", "cs_russiandrunk", "cs_siemonyetarian", "cs_solomon", "cs_stevehains", "cs_stretch",
	"cs_tanisha", "cs_taocheng", "cs_taostranslator", "cs_tenniscoach", "cs_terry", "cs_tom", "cs_tomepsilon", "cs_tracydisanto", "cs_wade", "cs_zimbor",
	"g_f_y_ballas_01", "g_f_y_families_01", "g_f_y_lost_01", "g_f_y_vagos_01", "g_m_m_armboss_01", "g_m_m_armgoon_01", "g_m_m_armlieut_01", "g_m_m_chemwork_01", "g_m_m_chemwork_01_p", "g_m_m_chiboss_01",
	"g_m_m_chiboss_01_p", "g_m_m_chicold_01", "g_m_m_chicold_01_p", "g_m_m_chigoon_01", "g_m_m_chigoon_01_p", "g_m_m_chigoon_02", "g_m_m_korboss_01", "g_m_m_mexboss_01", "g_m_m_mexboss_02", "g_m_y_armgoon_02",
	"g_m_y_azteca_01", "g_m_y_ballaeast_01", "g_m_y_ballaorig_01", "g_m_y_ballasout_01", "g_m_y_famca_01", "g_m_y_famdnf_01", "g_m_y_famfor_01", "g_m_y_korean_01", "g_m_y_korean_02", "g_m_y_korlieut_01",
	"g_m_y_lost_01", "g_m_y_lost_02", "g_m_y_lost_03", "g_m_y_mexgang_01", "g_m_y_mexgoon_01", "g_m_y_mexgoon_02", "g_m_y_mexgoon_03", "g_m_y_mexgoon_03_p", "g_m_y_pologoon_01", "g_m_y_pologoon_01_p",
	"g_m_y_pologoon_02", "g_m_y_pologoon_02_p", "g_m_y_salvaboss_01", "g_m_y_salvagoon_01", "g_m_y_salvagoon_02", "g_m_y_salvagoon_03", "g_m_y_salvagoon_03_p", "g_m_y_strpunk_01", "g_m_y_strpunk_02", "hc_driver",
	"hc_gunman", "hc_hacker", "ig_abigail", "ig_amandatownley", "ig_andreas", "ig_ashley", "ig_ballasog", "ig_bankman", "ig_barry", "ig_barry_p",
	"ig_bestmen", "ig_beverly", "ig_beverly_p", "ig_brad", "ig_bride", "ig_car3guy1", "ig_car3guy2", "ig_casey", "ig_chef", "ig_chengsr",
	"ig_chrisformage", "ig_clay", "ig_claypain", "ig_cletus", "ig_dale", "ig_davenorton", "ig_denise", "ig_devin", "ig_dom", "ig_dreyfuss",
	"ig_drfriedlander", "ig_fabien", "ig_fbisuit_01", "ig_floyd", "ig_groom", "ig_hao", "ig_hunter", "ig_janet", "ig_jay_norris", "ig_jewelass",
	"ig_jimmyboston", "ig_jimmydisanto", "ig_joeminuteman", "ig_johnnyklebitz", "ig_josef", "ig_josh", "ig_kerrymcintosh", "ig_lamardavis", "ig_lazlow", "ig_lestercrest",
	"ig_lifeinvad_01", "ig_lifeinvad_02", "ig_magenta", "ig_manuel", "ig_marnie", "ig_maryann", "ig_maude", "ig_michelle", "ig_milton", "ig_molly",
	"ig_mrk", "ig_mrsphillips", "ig_mrs_thornhill", "ig_natalia", "ig_nervousron", "ig_nigel", "ig_old_man1a", "ig_old_man2", "ig_omega", "ig_oneil",
	"ig_orleans", "ig_ortega", "ig_paper", "ig_patricia", "ig_priest", "ig_prolsec_02", "ig_ramp_gang", "ig_ramp_hic", "ig_ramp_hipster", "ig_ramp_mex",
	"ig_roccopelosi", "ig_russiandrunk", "ig_screen_writer", "ig_siemonyetarian", "ig_solomon", "ig_stevehains", "ig_stretch", "ig_talina", "ig_tanisha", "ig_taocheng",
	"ig_taostranslator", "ig_taostranslator_p", "ig_tenniscoach", "ig_terry", "ig_tomepsilon", "ig_tonya", "ig_tracydisanto", "ig_trafficwarden", "ig_tylerdix", "ig_wade",
	"ig_zimbor", "mp_f_deadhooker", "mp_f_freemode_01", "mp_f_misty_01", "mp_f_stripperlite", "mp_g_m_pros_01", "mp_headtargets", "mp_m_claude_01", "mp_m_exarmy_01", "mp_m_famdd_01",
	"mp_m_fibsec_01", "mp_m_freemode_01", "mp_m_marston_01", "mp_m_niko_01", "mp_m_shopkeep_01", "mp_s_m_armoured_01", "", "", "", "",
	"", "s_f_m_fembarber", "s_f_m_maid_01", "s_f_m_shop_high", "s_f_m_sweatshop_01", "s_f_y_airhostess_01", "s_f_y_bartender_01", "s_f_y_baywatch_01", "s_f_y_cop_01", "s_f_y_factory_01",
	"s_f_y_hooker_01", "s_f_y_hooker_02", "s_f_y_hooker_03", "s_f_y_migrant_01", "s_f_y_movprem_01", "s_f_y_ranger_01", "s_f_y_scrubs_01", "s_f_y_sheriff_01", "s_f_y_shop_low", "s_f_y_shop_mid",
	"s_f_y_stripperlite", "s_f_y_stripper_01", "s_f_y_stripper_02", "s_f_y_sweatshop_01", "s_m_m_ammucountry", "s_m_m_armoured_01", "s_m_m_armoured_02", "s_m_m_autoshop_01", "s_m_m_autoshop_02", "s_m_m_bouncer_01",
	"s_m_m_chemsec_01", "s_m_m_ciasec_01", "s_m_m_cntrybar_01", "s_m_m_dockwork_01", "s_m_m_doctor_01", "s_m_m_fiboffice_01", "s_m_m_fiboffice_02", "s_m_m_gaffer_01", "s_m_m_gardener_01", "s_m_m_gentransport",
	"s_m_m_hairdress_01", "s_m_m_highsec_01", "s_m_m_highsec_02", "s_m_m_janitor", "s_m_m_lathandy_01", "s_m_m_lifeinvad_01", "s_m_m_linecook", "s_m_m_lsmetro_01", "s_m_m_mariachi_01", "s_m_m_marine_01",
	"s_m_m_marine_02", "s_m_m_migrant_01", "u_m_y_zombie_01", "s_m_m_movprem_01", "s_m_m_movspace_01", "s_m_m_paramedic_01", "s_m_m_pilot_01", "s_m_m_pilot_02", "s_m_m_postal_01", "s_m_m_postal_02",
	"s_m_m_prisguard_01", "s_m_m_scientist_01", "s_m_m_security_01", "s_m_m_snowcop_01", "s_m_m_strperf_01", "s_m_m_strpreach_01", "s_m_m_strvend_01", "s_m_m_trucker_01", "s_m_m_ups_01", "s_m_m_ups_02",
	"s_m_o_busker_01", "s_m_y_airworker", "s_m_y_ammucity_01", "s_m_y_armymech_01", "s_m_y_autopsy_01", "s_m_y_barman_01", "s_m_y_baywatch_01", "s_m_y_blackops_01", "s_m_y_blackops_02", "s_m_y_busboy_01",
	"s_m_y_chef_01", "s_m_y_clown_01", "s_m_y_construct_01", "s_m_y_construct_02", "s_m_y_cop_01", "s_m_y_dealer_01", "s_m_y_devinsec_01", "s_m_y_dockwork_01", "s_m_y_doorman_01", "s_m_y_dwservice_01",
	"s_m_y_dwservice_02", "s_m_y_factory_01", "s_m_y_fireman_01", "s_m_y_garbage", "s_m_y_grip_01", "s_m_y_hwaycop_01", "s_m_y_marine_01", "s_m_y_marine_02", "s_m_y_marine_03", "s_m_y_mime",
	"s_m_y_pestcont_01", "s_m_y_pilot_01", "s_m_y_prismuscl_01", "s_m_y_prisoner_01", "s_m_y_ranger_01", "s_m_y_robber_01", "s_m_y_sheriff_01", "s_m_y_shop_mask", "s_m_y_strvend_01", "s_m_y_swat_01",
	"s_m_y_uscg_01", "s_m_y_valet_01", "s_m_y_waiter_01", "s_m_y_winclean_01", "s_m_y_xmech_01", "s_m_y_xmech_02", "u_f_m_corpse_01", "u_f_m_miranda", "u_f_m_promourn_01", "u_f_o_moviestar",
	"u_f_o_prolhost_01", "u_f_y_bikerchic", "u_f_y_comjane", "u_f_y_corpse_01", "u_f_y_corpse_02", "u_f_y_hotposh_01", "u_f_y_jewelass_01", "u_f_y_mistress", "u_f_y_poppymich", "u_f_y_princess",
	"u_f_y_spyactress", "u_m_m_aldinapoli", "u_m_m_bankman", "u_m_m_bikehire_01", "u_m_m_fibarchitect", "u_m_m_filmdirector", "u_m_m_glenstank_01", "u_m_m_griff_01", "u_m_m_jesus_01", "u_m_m_jewelsec_01",
	"u_m_m_jewelthief", "u_m_m_markfost", "u_m_m_partytarget", "u_m_m_prolsec_01", "u_m_m_promourn_01", "u_m_m_rivalpap", "u_m_m_spyactor", "u_m_m_willyfist", "u_m_o_finguru_01", "u_m_o_taphillbilly",
	"u_m_o_tramp_01", "u_m_y_abner", "u_m_y_antonb", "u_m_y_babyd", "u_m_y_baygor", "u_m_y_burgerdrug_01", "u_m_y_chip", "u_m_y_cyclist_01", "u_m_y_fibmugger_01", "u_m_y_guido_01",
	"u_m_y_gunvend_01", "u_m_y_hippie_01", "u_m_y_imporage", "u_m_y_justin", "u_m_y_mani", "u_m_y_militarybum", "u_m_y_paparazzi", "u_m_y_party_01", "u_m_y_pogo_01", "u_m_y_prisoner_01"}
-- ======================================= --
--  display text on screen
-- ======================================= --
function spawnMe.draw_text(text, x, y, scale)
	UI.SET_TEXT_FONT(0);
	UI.SET_TEXT_SCALE(scale, scale);
	UI.SET_TEXT_COLOUR(255, 255, 255, 255);
	UI.SET_TEXT_WRAP(0.0, 1.0);
	UI.SET_TEXT_CENTRE(false);
	UI.SET_TEXT_DROPSHADOW(2, 2, 0, 0, 0);
	UI.SET_TEXT_EDGE(1, 0, 0, 0, 205);
	UI._SET_TEXT_ENTRY("STRING");
	UI._ADD_TEXT_COMPONENT_STRING(text);
	UI._DRAW_TEXT(y, x);
end
function spawnMe.displayHitText(txt)
	spawnMe.draw_text(txt, 0.7, 0.0005, 0.3);
end
-- ======================================= --
--  keep track of unique peds (seenPeds) table
-- ======================================= --
function spawnMe.isNewPed(ped) 
	for i=1,#spawnMe.seenPeds do
		if(spawnMe.seenPeds[i] == ped) then
			return false;
		end  
	end
	return true;
end
-- ======================================= --
--  add to seenPeds table when unique
-- ======================================= --
function spawnMe.addToSeenList(ped)
	if (spawnMe.isNewPed(ped)) then
		table.insert(spawnMe.seenPeds,ped);
		return false;
	else
		return true;
	end   
end
-- ======================================= --
-- print Ped data to console for debugging
-- ======================================= --
function spawnMe.printPedData()
	for i=1,#spawnMe.seenPeds do
	  print(i,spawnMe.seenPeds[i]);
	end
	print("Total number:"..#spawnMe.seenPeds);
end
-- ======================================= --
--  Load next skin
-- ======================================= --
function spawnMe.nextSkin()
	local tmp = spawnMe.data["pointer"] + 1;
	if (#spawnMe.list > tmp)then
		spawnMe.data["pointer"] = tmp;
	else
		spawnMe.data["pointer"] = 1;
	end
	return spawnMe.list[tmp];
 end
-- ======================================= --
--  Find random existing ped to possess
-- ======================================= --
function spawnMe.findTarget()
	local playerPed = PLAYER.PLAYER_PED_ID();
	local PedTab,PedCount = PED.GET_PED_NEARBY_PEDS(playerPed, 1, -1);
	local randomNum = math.random( 1, PedCount); -- get random number up to # of peds
	spawnMe.data["pedcount"] = PedCount;
	local randomPed = PedTab[randomNum] -- Control set to new Ped
	PLAYER.CHANGE_PLAYER_PED(orig_player_index, randomPed, false, false);
	player = PLAYER.PLAYER_ID();
	playerPed = PLAYER.PLAYER_PED_ID();
	PLAYER.CLEAR_PLAYER_WANTED_LEVEL(player);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_PISTOL"), 2000, false);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_CARBINERIFLE"), 2000, false);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_GRENADE"), 100, false);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_STICKYBOMB"), 100, false);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_SMOKEGRENADE"), 100, false);
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_RPG"), 1000, false);
end
-- ======================================= --
--  given a skin name, return a new ped
-- ======================================= --
function spawnMe.makeClone(cloneTarget)
	local playerPed = PLAYER.PLAYER_PED_ID();
	local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(playerPed, 0.0, 2.0, 2.0);
	skin_hash = GAMEPLAY.GET_HASH_KEY(cloneTarget)
	STREAMING.REQUEST_MODEL(skin_hash)	
	wait(300); -- let the system load the skin
	local clone = PED.CREATE_PED(26, GAMEPLAY.GET_HASH_KEY(cloneTarget), coords.x, coords.y, coords.z, 1, false, true)
	local group = PLAYER.GET_PLAYER_GROUP(PLAYER.PLAYER_ID());
	PED.SET_PED_AS_GROUP_MEMBER(clone, GAMEPLAY.GET_HASH_KEY("army"));
	WEAPON.GIVE_DELAYED_WEAPON_TO_PED(clone, GAMEPLAY.GET_HASH_KEY("weapon_pistol"), 5, true);
	ENTITY.SET_ENTITY_INVINCIBLE(clone, false);
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(skin_hash);
	return clone;
end
-- ======================================= --
--  Given a skin name, 
--     spawnMe and possess a new ped
-- ======================================= --
function spawnMe.intoNew(targetSkin)
		local lastclone = spawnMe.data["clone"];
		spawnMe.data["clone"] = spawnMe.makeClone(targetSkin);
		wait(500); --  time to load the skin and clone
		PLAYER.CHANGE_PLAYER_PED(orig_player_index, spawnMe.data["clone"], false, false);
		spawnMe.addToSeenList(spawnMe.data["clone"]);
		-- reset player vars
		player = PLAYER.PLAYER_ID()
		playerPed = PLAYER.PLAYER_PED_ID()
		PLAYER.CLEAR_PLAYER_WANTED_LEVEL(player)
		ENTITY.SET_ENTITY_MAX_SPEED(playerPed, 1000);
	    ENTITY.SET_ENTITY_INVINCIBLE(playerPed, true);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_PISTOL"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_CARBINERIFLE"), 2000, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_GRENADE"), 100, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_STICKYBOMB"), 100, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_SMOKEGRENADE"), 100, false);
		WEAPON.GIVE_DELAYED_WEAPON_TO_PED(playerPed, GAMEPLAY.GET_HASH_KEY("WEAPON_RPG"), 1000, false);
		if (lastclone ~= nil) then
			ENTITY.SET_ENTITY_INVINCIBLE(lastclone, false);
			AI.TASK_COMBAT_HATED_TARGETS_AROUND_PED(lastclone, 5000, 0);
			PED.SET_PED_KEEP_TASK(lastclone, true);
		end
end
-- ======================================= --
--  Bodies will pile up if we don't clean up
-- ======================================= --
function spawnMe.clearTheDead()
	for k, ped in pairs(spawnMe.seenPeds) do
		if (ped ~= nil) then
			if (ENTITY.IS_ENTITY_DEAD(ped)) then
				PED.DELETE_PED(ped)
				spawnMe.seenPeds[k]= nil;
			end
		end
	end
end
-- ======================================= --
--  set original player credentials 
-- ======================================= --
function spawnMe.init()
	-- remember the original player model and index
	local playerPed = PLAYER.PLAYER_PED_ID()
	orig_player_model = ENTITY.GET_ENTITY_MODEL(playerPed);
	orig_player_index = PLAYER.GET_PLAYER_INDEX();
	math.randomseed( os.time() );
 	--local s = #spawnMe.list;
	--print("spawnMe list:"..s);
end
-- ======================================= --
--  Game loop
-- ======================================= --
function spawnMe.tick()
	local player = PLAYER.PLAYER_ID()
	local playerPed = PLAYER.PLAYER_PED_ID()
	local deathcheck = PLAYER.IS_PLAYER_DEAD(player)
	-- ======================================= --
	--  Press 'J' to jump into random ped
	-- ======================================= --
	if(get_key_pressed(74)) then -- 'J'
		--spawnMe.printPedData();
		spawnMe.findTarget();
		wait(1000);
	end
	-- ======================================= --
	--   Press 'K' to spawn 
	--     and possess ped with next Skin
	-- ======================================= --
	if(get_key_pressed(75)) then -- 'K'
		local skin = spawnMe.nextSkin(); 
		--print("next Model:"..skin);
		spawnMe.intoNew(skin); 
		wait(500);
	end
	-- ======================================= --
    -- I find the game will crash unless we
	-- return the player to the org state on death
	-- ======================================= --
	deathcheck = PLAYER.IS_PLAYER_DEAD(player);
	if(deathcheck == true)then
		PLAYER.SET_PLAYER_MODEL(player, orig_player_model);
	end
	-- ======================================= --
	-- show current used model name
	-- ======================================= --
	local p = spawnMe.data["pointer"];
	local txt = "Model["..spawnMe.data["pointer"].."]: "..spawnMe.list[p];
	spawnMe.draw_text(txt, 0.97, 0.5, 0.3);
	spawnMe.draw_text("[J][K] spawnMe v0.9 - "..#spawnMe.list.. " skins loaded",  0.76, 0.0005, 0.3);
	-- ======================================= --
	-- clear the dead
	-- ======================================= --
	if (spawnMe.settings["delete_the_dead"]) then
		spawnMe.clearTheDead();
	end
end
function spawnMe.unload()
end
return spawnMe;