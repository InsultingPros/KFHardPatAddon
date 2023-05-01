class Vampriarch extends HardPat_CIRCUS;

#exec load obj file=Vampriarch_T.utx
#exec load obj file=Vampriarch_A.ukx

simulated function CloakBoss() {
    local Controller C;
    local int Index;

    if (bSpotted) {
        Visibility = 120;

        if (Level.NetMode == NM_DedicatedServer) {
            return;
        }

        Skins[0] = Finalblend'KFX.StalkerGlow';
        Skins[1] = Finalblend'KFX.StalkerGlow';
        Skins[2] = Finalblend'KFX.StalkerGlow';
        bUnlit = true;
        return;
    }

    Visibility = 1;
    bCloaked = true;

    if (Level.NetMode != NM_Client) {
        for (C = Level.ControllerList; C != none; C = C.NextController) {
            if (C.bIsPlayer && C.Enemy == self) {
                C.Enemy = none; // Make bots lose sight with me.
            }
        }
    }

    if (Level.NetMode == NM_DedicatedServer) {
        return;
    }

    // sigh, now lets change this
    Skins[1] = Shader'KF_Specimens_Trip_T.patriarch_invisible_gun';
	Skins[0] = Shader'Vampriarch_T.Patriarch_Circus.pat_circus_body_invisible_shdr';
	Skins[2] = Shader'Vampriarch_T.Patriarch_Circus.patriarch_Head_Invisible_shdr';

    // Invisible - no shadow
    if (PlayerShadow != none) {
        PlayerShadow.bShadowActive = false;
    }

    // Remove/disallow projectors on invisible people
    Projectors.Remove(0, Projectors.Length);
    bAcceptsProjectors = false;
    SetOverlayMaterial(FinalBlend'KF_Specimens_Trip_T.patriarch_fizzle_FB', 1.0, true);

    // Randomly send out a message about Patriarch going invisible(10% chance)
    if (FRand() < 0.10) {
        // Pick a random Player to say the message
        Index = Rand(Level.Game.NumPlayers);
        for (C = Level.ControllerList; C != none; C = C.NextController) {
            if (PlayerController(C) != none) {
                if (Index == 0) {
                    PlayerController(C).Speech('AUTO', 8, "");
                    break;
                }
                Index--;
            }
        }
    }
}

static simulated function PreCacheMaterials(LevelInfo myLevel) {
    super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'Vampriarch_T.Patriarch_Circus.Patriarch_Circus_CMB');
    myLevel.AddPrecacheMaterial(Combiner'Vampriarch_T.Patriarch_Circus.Patriarch_Head_CMB');
}

defaultproperties {
    MenuName="Hard Vampriarch"

    DetachedArmClass=class'SeveredArmVampriarch'
    DetachedLegClass=class'SeveredLegVampriarch'
    DetachedHeadClass=class'SeveredHeadVampriarch'

    Mesh=SkeletalMesh'Vampriarch_A.Patriarch_Circus'

    Skins(0)=Combiner'Vampriarch_T.Patriarch_Circus.Patriarch_Circus_CMB'
    Skins(1)=Combiner'KF_Specimens_Trip_T.gatling_cmb'
    Skins(2)=Combiner'Vampriarch_T.Patriarch_Circus.Patriarch_Head_CMB'
}