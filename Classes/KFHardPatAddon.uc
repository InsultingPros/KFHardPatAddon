// Author        : Shtoyan
// Home Repo     : https://github.com/InsultingPros/KFHardPatAddon
// License       : https://www.gnu.org/licenses/gpl-3.0.en.html
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

    super.Mutate(MutateString, Sender);

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

    if (command ~= "PAT") {
        // allow only admins
        if (!CheckAdmin(Sender)) {
            SendMessage(Sender, "%wKFHardPatF requires %rADMIN %wprivileges!");
            return;
        }

        if (mod ~= "VAMPIRE" || mod ~= "4") {
            EventNum = 4;
            ActivateTimer();
            return;
        }
    }
}

defaultproperties {
    // same group so someone won't be able
    // to activate both mods at the same time
    GroupName="KF-BossMut"
    FriendlyName="KFHardPatF Addon V1"
    Description="Adds Vampriarch, cut from KF in 2011."

    bAddToServerPackages=true
    SeasonalVariants(4)=(idx=4,variant=class'Vampriarch')
}