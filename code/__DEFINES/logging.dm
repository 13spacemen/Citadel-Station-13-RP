// helpers
/// sets up a simple log. only use this for dumber logs that don't need any special logic.
#define SIMPLE_LOG_BOILERPLATE(type)						\
/world/_setup_logs_boilerplate(){							\
	GLOB.##type_log = "[GLOB.log_directory]/[#type].log";	\
	start_log(GLOB.##type_log);								\
}															\
/proc/log_##type(text){										\
	WRITE_LOG(GLOB.##type_log, text);						\
}															\
GLOBAL_PROTECT(##type_log);									\
GLOBAL_VAR(##type_log);

//Investigate logging defines
#define INVESTIGATE_ATMOS "atmos"
#define INVESTIGATE_CIRCUIT "circuit"
#define INVESTIGATE_PRESENTS "presents"
#define INVESTIGATE_RECORDS "records"
#define INVESTIGATE_SINGULO "singulo"
#define INVESTIGATE_SUPERMATTER "supermatter"
#define INVESTIGATE_TELESCI "telesci"

#define ALL_INVESTIGATE_SUBJECTS list(	\
	INVESTIGATE_ATMOS,					\
	INVESTIGATE_CIRCUIT,				\
	INVESTIGATE_PRESENTS,				\
	INVESTIGATE_RECORDS,				\
	INVESTIGATE_SINGULO,				\
	INVESTIGATE_SUPERMATTER,			\
	INVESTIGATE_TELESCI					\
)

// Logging types for log_message()
#define LOG_ATTACK (1 << 0)
#define LOG_SAY (1 << 1)
#define LOG_WHISPER (1 << 2)
#define LOG_EMOTE (1 << 3)
#define LOG_DSAY (1 << 4)
#define LOG_PDA (1 << 5)
#define LOG_CHAT (1 << 6)
#define LOG_COMMENT (1 << 7)
#define LOG_TELECOMMS (1 << 8)
#define LOG_OOC (1 << 9)
#define LOG_ADMIN (1 << 10)
#define LOG_OWNERSHIP (1 << 11)
#define LOG_GAME (1 << 12)
#define LOG_ADMIN_PRIVATE (1 << 13)
#define LOG_ASAY (1 << 14)
#define LOG_MECHA (1 << 15)
#define LOG_VIRUS (1 << 16)
#define LOG_CLONING (1 << 17)
#define LOG_SHUTTLE (1 << 18)
#define LOG_ECON (1 << 19)
#define LOG_VICTIM (1 << 20)
#define LOG_RADIO_EMOTE (1 << 21)

//Individual logging panel pages
#define INDIVIDUAL_ATTACK_LOG (LOG_ATTACK | LOG_VICTIM)
#define INDIVIDUAL_SAY_LOG (LOG_SAY | LOG_WHISPER | LOG_DSAY)
#define INDIVIDUAL_EMOTE_LOG (LOG_EMOTE | LOG_RADIO_EMOTE)
#define INDIVIDUAL_COMMS_LOG (LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS)
#define INDIVIDUAL_OOC_LOG (LOG_OOC | LOG_ADMIN)
#define INDIVIDUAL_OWNERSHIP_LOG (LOG_OWNERSHIP)
#define INDIVIDUAL_SHOW_ALL_LOG (LOG_ATTACK | LOG_SAY | LOG_WHISPER | LOG_EMOTE | LOG_RADIO_EMOTE | LOG_DSAY | LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS | LOG_OOC | LOG_ADMIN | LOG_OWNERSHIP | LOG_GAME | LOG_ADMIN_PRIVATE | LOG_ASAY | LOG_MECHA | LOG_VIRUS | LOG_CLONING | LOG_SHUTTLE | LOG_ECON | LOG_VICTIM)

#define LOGSRC_CKEY "Ckey"
#define LOGSRC_MOB "Mob"
