class KFHardPatAddon extends KFHardPatF
    config(KFHardPatAddon);

function PostBeginPlay() {
    // add original mod for further use
    AddToPackageMap("KFHardPatF");
    super.PostBeginPlay();
}

function Mutate(string MutateString, PlayerController Sender) {
    // ehh have to copy-paste this
    local int i;
    local array<String> wordsArray;
    local String command, mod;
    local array<String> modArray;

    // ignore empty cmds and dont go further
    Split(MutateString, " ", wordsArray);
    if (wordsArray.Length == 0) {
        return;
    }

    // do stuff with our cmd
    command = wordsArray[0];
    if (wordsArray.Length > 1) {
        mod = wordsArray[1];
    } else {
        mod = "";
    }

    i = 0;
    while (i + 1 < wordsArray.Length || i < 10) {
        if (i + 1 < wordsArray.Length) {
            modArray[i] = wordsArray[i+1];
        } else {
            modArray[i] = "";
        }
        i++;
    }

    super.Mutate(MutateString, Sender);

    if (mod ~= "VAMPIRE" || mod ~= "4") {
        EventNum = 4;
        ActivateTimer();
        return;
    }
}

// yeah i was super dumb, didn't make this modular...
// so enjoy yet another copy-paste job
function Timer() {
    if (bUseCustomMC && KFGT.MonsterCollection == class'KFGameType'.default.MonsterCollection) {
        KFGT.MonsterCollection = class'HPMonstersCollection';
        log("Hard Patriarch: HPMonstersCollection is loaded!");
    }

    switch (EventNum) {
        case 1:
            strSeasonalPat = "KFHardPatF.HardPat_XMAS";
            break;
        case 2:
            strSeasonalPat = "KFHardPatF.HardPat_CIRCUS";
            break;
        case 3:
            strSeasonalPat = "KFHardPatF.HardPat_HALLOWEEN";
            break;
        case 4:
            strSeasonalPat = "KFHardPatAddon.Vampriarch";
            break;
        default:
            strSeasonalPat = "KFHardPatF.HardPat";
    }
    log("Hard Patriarch: " $strSeasonalPat$ " is selected!");

    KFGT.EndGameBossClass = strSeasonalPat;

    if (KFGT.MonsterCollection != none) {
        KFGT.MonsterCollection.default.EndGameBossClass = strSeasonalPat;
    }

    if (!bBroadcast) {
        return;
    }

    BroadcastText("%rHard Pat Mutator%w:");
    BroadcastText("%b" $ strSeasonalPat $ " %wis activated!");
    bBroadcast = false;

    SetTimer(0.0, false);
    // Destroy();
}


defaultproperties {
    // same group so someone won't be able
    // to activate both mods at the same time
    GroupName="KF-BossMut"
    FriendlyName="KFHardPatF Addon V1"
    Description="Adds Vampriarch, cut from KF in 2011."

    bAddToServerPackages=true
}