#define SURGERY_NO_ROBOTIC (1<<0)
#define SURGERY_NO_CRYSTAL (1<<1)
#define SURGERY_NO_STUMP (1<<2)
#define SURGERY_NO_FLESH (1<<3)
/// Bodypart needs an incision or small cut
#define SURGERY_NEEDS_INCISION (1<<4)
/// Bodypart needs retracted incision or large cut
#define SURGERY_NEEDS_RETRACTED (1<<5)
/// Bodypart needs a broken bone AND retracted incision or large cut
#define SURGERY_NEEDS_DEENCASEMENT (1<<6)

/// Only one of this type of implant may be in a target
#define IMPLANT_HIGHLANDER (1<<0)
/// Shows implant name in body scanner
#define IMPLANT_KNOWN (1<<1)
/// Hides the implant from the body scanner completely
#define IMPLANT_HIDDEN (1<<2)
