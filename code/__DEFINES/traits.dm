// trait accessor defines
#define ADD_TRAIT(target, trait, source) \
	do { \
		var/list/_L; \
		if (!target.status_traits) { \
			target.status_traits = list(); \
			_L = target.status_traits; \
			_L[trait] = list(source); \
		} else { \
			_L = target.status_traits; \
			if (_L[trait]) { \
				_L[trait] |= list(source); \
			} else { \
				_L[trait] = list(source); \
			} \
		} \
	} while (0)
#define REMOVE_TRAIT(target, trait, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources\
		}; \
		if (_L && _L[trait]) { \
			for (var/_T in _L[trait]) { \
				if ((!_S && (_T != ROUNDSTART_TRAIT)) || (_T in _S)) { \
					_L[trait] -= _T \
				} \
			};\
			if (!length(_L[trait])) { \
				_L -= trait \
			}; \
			if (!length(_L)) { \
				target.status_traits = null \
			}; \
		} \
	} while (0)
#define REMOVE_TRAITS_NOT_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] &= _S;\
				if (!length(_L[_T])) { \
					_L -= _T } \
				};\
				if (!length(_L)) { \
					target.status_traits = null\
				};\
		}\
	} while (0)
#define HAS_TRAIT(target, trait) (target.status_traits ? (target.status_traits[trait] ? TRUE : FALSE) : FALSE)
#define HAS_TRAIT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (source in target.status_traits[trait]) : FALSE) : FALSE)

/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

//mob traits
#define TRAIT_BLIND 			"blind"
#define TRAIT_MUTE				"mute"
/*
#define TRAIT_EMOTEMUTE			"emotemute"
*/
#define TRAIT_DEAF				"deaf"
/*
#define TRAIT_NEARSIGHT			"nearsighted"
#define TRAIT_FAT				"fat"
#define TRAIT_HUSK				"husk"
#define TRAIT_BADDNA			"baddna"
#define TRAIT_CLUMSY			"clumsy"
///means that you can't use weapons with normal trigger guards.
#define TRAIT_CHUNKYFINGERS		"chunkyfingers"
#define TRAIT_DUMB				"dumb"
///sets IsAdvancedToolUser to FALSE
#define TRAIT_MONKEYLIKE		"monkeylike"
#define TRAIT_PACIFISM			"pacifism"
#define TRAIT_IGNORESLOWDOWN	"ignoreslow"
#define TRAIT_IGNOREDAMAGESLOWDOWN "ignoredamageslowdown"
///Causes death-like unconsciousness
#define TRAIT_DEATHCOMA			"deathcoma"
///Makes the owner appear as dead to most forms of medical examination
#define TRAIT_FAKEDEATH			"fakedeath"
#define TRAIT_DISFIGURED		"disfigured"
*/
///Tracks whether we're gonna be a baby alien's mummy.
#define TRAIT_XENO_HOST			"xeno_host"
///Tracks whether you're a mime or not.
#define TRAIT_MIMING			"miming"
/*
#define TRAIT_STUNIMMUNE		"stun_immunity"
#define TRAIT_STUNRESISTANCE    "stun_resistance"
#define TRAIT_SLEEPIMMUNE		"sleep_immunity"
#define TRAIT_PUSHIMMUNE		"push_immunity"
#define TRAIT_SHOCKIMMUNE		"shock_immunity"
#define TRAIT_STABLEHEART		"stable_heart"
#define TRAIT_STABLELIVER		"stable_liver"
#define TRAIT_RESISTHEAT		"resist_heat"
///For when you want to be able to touch hot things, but still want fire to be an issue.
#define TRAIT_RESISTHEATHANDS	"resist_heat_handsonly"
#define TRAIT_RESISTCOLD		"resist_cold"
#define TRAIT_RESISTHIGHPRESSURE	"resist_high_pressure"
#define TRAIT_RESISTLOWPRESSURE	"resist_low_pressure"
#define TRAIT_RADIMMUNE			"rad_immunity"
#define TRAIT_VIRUSIMMUNE		"virus_immunity"
#define TRAIT_PIERCEIMMUNE		"pierce_immunity"
#define TRAIT_NODISMEMBER		"dismember_immunity"
#define TRAIT_NOFIRE			"nonflammable"
#define TRAIT_NOGUNS			"no_guns"
#define TRAIT_NOHUNGER			"no_hunger"
#define TRAIT_NOMETABOLISM		"no_metabolism"
#define TRAIT_TOXIMMUNE			"toxin_immune"
#define TRAIT_EASYDISMEMBER		"easy_dismember"
#define TRAIT_LIMBATTACHMENT 	"limb_attach"
#define TRAIT_NOLIMBDISABLE		"no_limb_disable"
#define TRAIT_EASYLIMBDISABLE	"easy_limb_disable"
#define TRAIT_TOXINLOVER		"toxinlover"
#define TRAIT_NOBREATH			"no_breath"
*/
#define TRAIT_ANTIMAGIC			"anti_magic"
#define TRAIT_HOLY				"holy"
/*
#define TRAIT_DEPRESSION		"depression"
#define TRAIT_JOLLY				"jolly"
#define TRAIT_NOCRITDAMAGE		"no_crit"
#define TRAIT_NOSLIPWATER		"noslip_water"
#define TRAIT_NOSLIPALL			"noslip_all"
#define TRAIT_NODEATH			"nodeath"
#define TRAIT_NOHARDCRIT		"nohardcrit"
#define TRAIT_NOSOFTCRIT		"nosoftcrit"
#define TRAIT_MINDSHIELD		"mindshield"
#define TRAIT_DISSECTED			"dissected"
///I can hear dead people
#define TRAIT_SIXTHSENSE		"sixth_sense"
#define TRAIT_FEARLESS			"fearless"
///These are used for brain-based paralysis, where replacing the limb won't fix it
#define TRAIT_PARALYSIS_L_ARM	"para-l-arm"
#define TRAIT_PARALYSIS_R_ARM	"para-r-arm"
#define TRAIT_PARALYSIS_L_LEG	"para-l-leg"
#define TRAIT_PARALYSIS_R_LEG	"para-r-leg"
#define TRAIT_CANNOT_OPEN_PRESENTS "cannot-open-presents"
#define TRAIT_PRESENT_VISION    "present-vision"
#define TRAIT_DISK_VERIFIER     "disk-verifier"
#define TRAIT_NOMOBSWAP         "no-mob-swap"
#define TRAIT_XRAY_VISION       "xray_vision"
#define TRAIT_THERMAL_VISION    "thermal_vision"
#define TRAIT_ABDUCTOR_TRAINING "abductor-training"
#define TRAIT_ABDUCTOR_SCIENTIST_TRAINING "abductor-scientist-training"
#define TRAIT_SURGEON           "surgeon"
#define	TRAIT_STRONG_GRABBER	"strong_grabber"
#define	TRAIT_MAGIC_CHOKE		"magic_choke"
#define TRAIT_SOOTHED_THROAT    "soothed-throat"
#define TRAIT_LAW_ENFORCEMENT_METABOLISM "law-enforcement-metabolism"
#define TRAIT_ALWAYS_CLEAN      "always-clean"
#define TRAIT_BOOZE_SLIDER      "booze-slider"
#define TRAIT_UNINTELLIGIBLE_SPEECH "unintelligible-speech"
#define TRAIT_UNSTABLE			"unstable"
#define TRAIT_OIL_FRIED			"oil_fried"
#define TRAIT_MEDICAL_HUD		"med_hud"
#define TRAIT_SECURITY_HUD		"sec_hud"
///Is a medibot healing you
#define TRAIT_MEDIBOTCOMINGTHROUGH "medibot"
#define TRAIT_PASSTABLE			"passtable"

//non-mob traits
///Used for limb-based paralysis, where replacing the limb will fix it
#define TRAIT_PARALYSIS			"paralysis"
// item traits
*/
#define TRAIT_NODROP            "nodrop"
#define TRAIT_DISRUPTED			"disrupted"
/*
/// Visible on t-ray scanners if the atom/var/level == 1
#define TRAIT_T_RAY_VISIBLE     "t-ray-visible"
///you just can't
#define TRAIT_NO_TELEPORT		"no-teleport"
//quirk traits
#define TRAIT_ALCOHOL_TOLERANCE	"alcohol_tolerance"
#define TRAIT_AGEUSIA			"ageusia"
#define TRAIT_HEAVY_SLEEPER		"heavy_sleeper"
#define TRAIT_NIGHT_VISION		"night_vision"
#define TRAIT_LIGHT_STEP		"light_step"
#define TRAIT_SPIRITUAL			"spiritual"
#define TRAIT_VORACIOUS			"voracious"
#define TRAIT_SELF_AWARE		"self_aware"
#define TRAIT_FREERUNNING		"freerunning"
#define TRAIT_SKITTISH			"skittish"
#define TRAIT_POOR_AIM			"poor_aim"
#define TRAIT_PROSOPAGNOSIA		"prosopagnosia"
#define TRAIT_DRUNK_HEALING		"drunk_healing"
#define TRAIT_TAGGER			"tagger"
#define TRAIT_PHOTOGRAPHER		"photographer"
#define TRAIT_MUSICIAN			"musician"
#define TRAIT_LIGHT_DRINKER		"light_drinker"
#define TRAIT_EMPATH			"empath"
#define TRAIT_FRIENDLY			"friendly"
#define TRAIT_GRABWEAKNESS		"grab_weakness"
*/

// common trait sources
#define GENERIC_TRAIT "generic"
/*
#define EYE_DAMAGE "eye_damage"
#define GENETIC_MUTATION "genetic"
#define OBESITY "obesity"
*/
#define MAGIC_TRAIT "magic"
/*
#define TRAUMA_TRAIT "trauma"
#define DISEASE_TRAIT "disease"
#define SPECIES_TRAIT "species"
#define ORGAN_TRAIT "organ"
*/
///cannot be removed without admin intervention
#define ROUNDSTART_TRAIT "roundstart"
#define HOLOGRAM_TRAIT "hologram"
#define GHOSTROLE_TRAIT "ghostrole"
#define JOB_TRAIT "job"
///Mime trait.
#define TRAIT_MIME "mime"
/*
#define CYBORG_ITEM_TRAIT "cyborg-item"
*/
/// (B)admins only.
#define ADMIN_TRAIT "admin"
/*
#define CHANGELING_TRAIT "changeling"
#define CULT_TRAIT "cult"
/// The item is magically cursed
#define CURSED_ITEM_TRAIT "cursed-item"
#define ABSTRACT_ITEM_TRAIT "abstract-item"
#define STATUS_EFFECT_TRAIT "status-effect"
*/
#define CLOTHING_TRAIT "clothing"
#define RIG_TRAIT "rig"
#define MAGBOOT_TRAIT "magboot"
#define TOGGLE_CLOTHING_TRAIT "toggle_clothing"
#define AUGMENT_TRAIT "trait"
#define CYBORG_MODULE_TRAIT "cyborg_module"
/*
#define GLASSES_TRAIT "glasses"
/// inherited from riding vehicles
#define VEHICLE_TRAIT "vehicle"
#define INNATE_TRAIT "innate"

// unique trait sources, still defines
#define CLONING_POD_TRAIT "cloning-pod"
#define STATUE_MUTE "statue"
#define CHANGELING_DRAIN "drain"
#define CHANGELING_HIVEMIND_MUTE "ling_mute"
#define ABYSSAL_GAZE_BLIND "abyssal_gaze"
#define HIGHLANDER "highlander"
#define TRAIT_HULK "hulk"
#define STASIS_MUTE "stasis"
#define GENETICS_SPELL "genetics_spell"
#define EYES_COVERED "eyes_covered"
#define CULT_EYES "cult_eyes"
#define TRAIT_SANTA "santa"
#define SCRYING_ORB "scrying-orb"
#define ABDUCTOR_ANTAGONIST "abductor-antagonist"
#define NUKEOP_TRAIT "nuke-op"
#define DEATHSQUAD_TRAIT "deathsquad"
#define MEGAFAUNA_TRAIT "megafauna"
#define CLOWN_NUKE_TRAIT "clown-nuke"
#define STICKY_MOUSTACHE_TRAIT "sticky-moustache"
#define CHAINSAW_FRENZY_TRAIT "chainsaw-frenzy"
#define CHRONO_GUN_TRAIT "chrono-gun"
#define REVERSE_BEAR_TRAP_TRAIT "reverse-bear-trap"
#define CURSED_MASK_TRAIT "cursed-mask"
#define HIS_GRACE_TRAIT "his-grace"
*/
#define HAND_REPLACEMENT_TRAIT "magic-hand"
/*
#define HOT_POTATO_TRAIT "hot-potato"
#define SABRE_SUICIDE_TRAIT "sabre-suicide"
#define ABDUCTOR_VEST_TRAIT "abductor-vest"
#define CAPTURE_THE_FLAG_TRAIT "capture-the-flag"
#define EYE_OF_GOD_TRAIT "eye-of-god"
#define SHAMEBRERO_TRAIT "shamebrero"
#define CHRONOSUIT_TRAIT "chronosuit"
#define LOCKED_HELMET_TRAIT "locked-helmet"
#define NINJA_SUIT_TRAIT "ninja-suit"
#define ANTI_DROP_IMPLANT_TRAIT "anti-drop-implant"
#define VR_ZONE_TRAIT "vr_zone_trait"
#define SLEEPING_CARP_TRAIT "sleeping_carp"
#define SANGUIOSE_TRAIT "sanguiose"
#define FROGENITE_TRAIT "frogenite"
#define FERVEATIUM_TRAIT "ferveatium"
*/

#define CHANGELING_TRAIT "changeling"
#define TECHNOMANCER_TRAIT "technomancer"
