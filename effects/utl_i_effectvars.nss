//::///////////////////////////////////////////////
//:: Utility Include: Effect Variables
//:: utl_i_effectvars.nss
//:://////////////////////////////////////////////
/*
    8193.23 added GetEffectInteger and other ways to get actual values from effects.

    This means we can now get more accurate values for certain things, for instance testing
    what attack bonuses are valid.
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////


// Complement ATTACK_BONUS_* constants
const int ATTACK_BONUS_CWEAPON1 = 3;
const int ATTACK_BONUS_CWEAPON2 = 4;
const int ATTACK_BONUS_CWEAPON3 = 5;
const int ATTACK_BONUS_UNARMED  = 7;


// This will work through the negative level effects on oCreature and figure out what the
// "real" levels of the class levels of nSlot are
// - oCreature - The creature to check
// - nSlot - The slot to check, 1, 2, or 3 as per GetClassByPosition
// * Returns 0 on error (such as them not having any amount of the given class)
int GetClassLevelsIncludingNegativeLevelsBySlot(object oCreature, int nSlot);

// This will work through the negative level effects on oCreature and figure out what the
// "real" levels of nClass is.
// - oCreature - The creature to check
// - nClass - The class to check
// * Returns 0 on error (such as them not having any amount of the given class)
int GetClassLevelsIncludingNegativeLevels(object oCreature, int nClass);

// This will total up:
// The best specific bonus if a specific ATTACK_BONUS_* is used (other than MISC)
// by checking relevant item properties and effects.
// All the ATTACK_BONUS_MISC values which get totalled up.
// Note: ATTACK_BONUS_UNARMED ignores if the given creature is going to be performing
// unarmed attacks or not.
// Note: oTarget if OBJECT_INVALID will assume all the attack bonuses against specific
// alignments or races will fail, and only generic bonuses will be added.
// * Returns 0 on error
int GetEffectAttackBonuses(object oCreature, int nAttackBonus = ATTACK_BONUS_MISC, object oTarget = OBJECT_INVALID);

// This will return the amount of change in the given attack for for EffectAttackIncrease or
// EffectAttackDecrease
// - eAttackEffect - an Attack Increase or Attack Decrease effect
// * Returns -1 on error
int GetEffectAttackChangeAmount(effect eAttackEffect);

// This will return the ATTACK_BONUS_* type for EffectAttackIncrease or
// EffectAttackDecrease (although only increase can have it specified in scripts).
// - eAttackEffect - an Attack Increase or Attack Decrease effect
// * Returns -1 on error
int GetEffectAttackChangeBonusType(effect eAttackEffect);

// This will get the movement speed increase of the given effect
// Do this calculation to get the final change: IntToFloat(Return Value)/100.0
// 150 = * 1.5 speed
// 110 = * 1.1 speed
// - eEffect - Effect to check
// * Returns 0 on error
int GetEffectMovementSpeedIncreaseAmount(effect eEffect);

// This will get the movement speed increase of the given effect
// Do this calculation to get the final change: 1.0 - IntToFloat(Return Value)/100.0
// 50 = * 0.5 speed
// 80 = * 0.2 speed
// - eEffect - Effect to check
// * Returns 0 on error
int GetEffectMovementSpeedDecreaseAmount(effect eEffect);

// This will total up the multipliers of speed changes applied to oTarget.
// The cap is 0.125 minimum and 1.5 maximum (except people with 3 or more Monk levels, where it is 3.0 maximum).
// This is then multiplied to whatever usual rate of movement the
//
// There are some known bugs, see: https://nwnlexicon.com/index.php?title=EffectMovementSpeedDecrease#Effect_Breakdown
// Run FixMovementSpeedEffectsModifiers() after applying a new effect to get a proper fixed total.
// * oCreature - Creature to check effects of
float GetTotalMovementSpeedEffectsModifier(object oCreature);

// This will apply a 100 speed increase (which has no effect) and immediately remove it. Once removed
// the speed increases and decreases get recalculated.
void FixMovementSpeedEffectsModifiers(object oCreature);

// This function is currently INCOMPLETE and may have some issues being a true fully working function.
// This will return the total saving throw bonus with a given saving throw type and if it is a spell
// adds on the spellcraft save bonus.
// - nSave - SAVING_THROW_* eg SAVING_THROW_WILL
// - oObject - The object to get saving throw of (Creature, Door, Placeable)
// - Opponent - If present will be used for race/alignement specific saving throw bonuses
// - nSaveType - SAVING_THROW_TYPE_* value, eg: SAVING_THROW_TYPE_FIRE
// - bSpell - If TRUE will also assume nSaveType adds SAVING_THROW_TYPE_SPELL
//     SAVING_THROW_TYPE_SPELL adds spell-specific saves but also a bonus from spellcraft.
// * Returns -100 on error (should always fail that save!)
int GetEffectSavingThrowBonuses(int nSave, object oObject, object oOpponent = OBJECT_INVALID, int nSaveType = SAVING_THROW_TYPE_NONE, int bSpell = FALSE);




// This will work through the negative level effects on oCreature and figure out what the
// "real" levels of the class levels of nSlot are
// - oCreature - The creature to check
// - nSlot - The slot to check, 1, 2, or 3 as per GetClassByPosition
// * Returns 0 on error (such as them not having any amount of the given class)
int GetClassLevelsIncludingNegativeLevelsBySlot(object oCreature, int nSlot)
{
    int nClassLevels = GetLevelByClass(GetClassByPosition(nSlot, oCreature), oCreature);

    // Negative level tracking
    int nNegativeLevels = 0;

    // Change nSlot to be 0 indexed
    nSlot--;

    // Get the negative level effects affecting the given class position
    effect eCheck = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == EFFECT_TYPE_NEGATIVELEVEL)
        {
            if(GetEffectInteger(eCheck, 1) == nSlot)
            {
                nNegativeLevels += GetEffectInteger(eCheck, 0);
            }
        }
    }
    return nClassLevels - nNegativeLevels;
}

// This will work through the negative level effects on oCreature and figure out what the
// "real" levels of nClass is.
// - oCreature - The creature to check
// - nClass - The class to check
// * Returns 0 on error (such as them not having any amount of the given class)
int GetClassLevelsIncludingNegativeLevels(object oCreature, int nClass)
{
    int nClassLevels = GetLevelByClass(nClass, oCreature);
    if(nClassLevels == 0) return 0;

    int nClassByPosition = GetClassByPosition(1, oCreature);
    if(nClassByPosition == nClass)
    {
        return GetClassLevelsIncludingNegativeLevelsBySlot(oCreature, 1);
    }
    else
    {
        nClassByPosition = GetClassByPosition(2, oCreature);
        if(nClassByPosition == nClass)
        {
            return GetClassLevelsIncludingNegativeLevelsBySlot(oCreature, 2);
        }
        else
        {
            nClassByPosition = GetClassByPosition(3, oCreature);
            if(nClassByPosition == nClass)
            {
                return GetClassLevelsIncludingNegativeLevelsBySlot(oCreature, 3);
            }
        }
    }
    // Should never happen...
    return 0;
}

// This will total up:
// The best specific bonus if a specific ATTACK_BONUS_* is used (other than MISC)
// by checking relevant item properties and effects.
// All the ATTACK_BONUS_MISC values which get totalled up.
// Note: ATTACK_BONUS_UNARMED ignores if the given creature is going to be performing
// unarmed attacks or not.
// Note: oTarget if OBJECT_INVALID will assume all the attack bonuses against specific
// alignments or races will fail, and only generic bonuses will be added.
// * Returns 0 on error
int GetEffectAttackBonuses(object oCreature, int nAttackBonus = ATTACK_BONUS_MISC, object oTarget = OBJECT_INVALID)
{
    if(!GetIsObjectValid(oCreature)) return 0;

    // Changes - always positive integers.
    int nAttackBonus = 0;
    int nAttackPenalty = 0;
    int nWeaponBonus = 0;
    int nWeaponPenalty = 0;
    // Haste/Slow, positive for haste, negative for slow
    int nHasteSlow = 0;

    // Other variables
    int nValue;
    int nRace = GetRacialType(oTarget);
    int nGoodEvil = GetAlignmentGoodEvil(oTarget);
    int nLawChaos = GetAlignmentLawChaos(oTarget);

    // Check the specific slot
    int nSlot = -1;
    switch(nAttackBonus)
    {
        case ATTACK_BONUS_ONHAND: nSlot = INVENTORY_SLOT_RIGHTHAND; break;
        case ATTACK_BONUS_OFFHAND: nSlot = INVENTORY_SLOT_LEFTHAND; break;
        case ATTACK_BONUS_CWEAPON1: nSlot = INVENTORY_SLOT_CWEAPON_L; break;
        case ATTACK_BONUS_CWEAPON2: nSlot = INVENTORY_SLOT_CWEAPON_R; break;
        case ATTACK_BONUS_CWEAPON3: nSlot = INVENTORY_SLOT_CWEAPON_B; break;
        case ATTACK_BONUS_UNARMED: nSlot = INVENTORY_SLOT_ARMS; break;
    }

    // Check if valid
    if(nSlot != -1)
    {
        object oItem = GetItemInSlot(nSlot, oCreature);
        if(GetIsObjectValid(oItem))
        {
            int nType;
            // Check item properties
            itemproperty ip = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ip))
            {
                // Look for attack increase and decrease, and enchantment increase, for highest.
                switch(GetItemPropertyType(ip))
                {
                    // Attack bonuses
                    case ITEM_PROPERTY_ATTACK_BONUS:
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                        nValue = GetItemPropertyCostTableValue(ip);
                        if(nValue > nWeaponBonus) nWeaponBonus = nValue;
                    break;

                    case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
                        nValue = GetItemPropertySubType(ip);
                        // The alignment groups are distinct, so can be either of ours
                        if(nValue == nGoodEvil || nValue == nLawChaos)
                        {
                            nValue = GetItemPropertyCostTableValue(ip);
                            if(nValue > nWeaponBonus) nWeaponBonus = nValue;
                        }
                    break;
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
                        if(GetItemPropertySubType(ip) == nRace)
                        {
                            nValue = GetItemPropertyCostTableValue(ip);
                            if(nValue > nWeaponBonus) nWeaponBonus = nValue;
                        }
                    break;
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
                        nValue = 0;
                        // Sadly specific alignments are weird
                        switch(GetItemPropertySubType(ip))
                        {
                            case IP_CONST_ALIGNMENT_LG: nValue = (nLawChaos == ALIGNMENT_LAWFUL && nGoodEvil == ALIGNMENT_GOOD); break;
                            case IP_CONST_ALIGNMENT_NG: nValue = (nLawChaos == ALIGNMENT_NEUTRAL && nGoodEvil == ALIGNMENT_GOOD); break;
                            case IP_CONST_ALIGNMENT_CG: nValue = (nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_GOOD); break;
                            case IP_CONST_ALIGNMENT_LN: nValue = (nLawChaos == ALIGNMENT_LAWFUL && nGoodEvil == ALIGNMENT_NEUTRAL); break;
                            case IP_CONST_ALIGNMENT_TN: nValue = (nLawChaos == ALIGNMENT_NEUTRAL && nGoodEvil == ALIGNMENT_NEUTRAL); break;
                            case IP_CONST_ALIGNMENT_CN: nValue = (nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_NEUTRAL); break;
                            case IP_CONST_ALIGNMENT_LE: nValue = (nLawChaos == ALIGNMENT_LAWFUL && nGoodEvil == ALIGNMENT_EVIL); break;
                            case IP_CONST_ALIGNMENT_NE: nValue = (nLawChaos == ALIGNMENT_NEUTRAL && nGoodEvil == ALIGNMENT_EVIL); break;
                            case IP_CONST_ALIGNMENT_CE: nValue = (nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_EVIL); break;
                        }
                        // Valid?
                        if(nValue)
                        {
                            nValue = GetItemPropertyCostTableValue(ip);
                            if(nValue > nWeaponBonus) nWeaponBonus = nValue;
                        }
                    break;

                    // Decreases
                    case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
                    case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
                        nValue = GetItemPropertyCostTableValue(ip);
                        if(nValue > nWeaponPenalty) nWeaponPenalty = nValue;
                    break;
                }
                ip = GetNextItemProperty(oItem);
            }
        }
    }

    // Effects that affect attack:
    // - EffectAttackIncrease - variable race/alignment, increase amount
    // - EffectAttackDecrease - variable race/alignment, decrease amount
    //      - Note: Called Shot: Legs applies -2 of this effect type (but has an invalid subtype)
    // "Hidden" ones:
    // - EffectEntangle, -2 misc
    // - EffectSlow, -2 misc (if haste doesn't normalise it to 0)
    // - EffectNegativeLevel, -1 misc per level
    effect eCheck = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eCheck))
    {
        nValue = GetEffectType(eCheck);
        if(nValue == EFFECT_TYPE_ATTACK_INCREASE)
        {
            // Check race etc.
            nValue = GetEffectInteger(eCheck, 2);
            if(nValue == RACIAL_TYPE_INVALID ||
               nValue == nRace)
            {
                // Alignment Law/Chaos
                nValue = GetEffectInteger(eCheck, 3);
                if(nValue == ALIGNMENT_ALL ||
                   nValue == nLawChaos)
                {
                    // Alignment Good/Evil
                    nValue = GetEffectInteger(eCheck, 4);
                    if(nValue == ALIGNMENT_ALL ||
                       nValue == nGoodEvil)
                    {
                        // Attack bonus type (misc or specific)
                        nValue = GetEffectInteger(eCheck, 1);
                        if(nValue == nAttackBonus || nValue == ATTACK_BONUS_MISC)
                        {
                            // All misc bonuses are added
                            if(nValue == ATTACK_BONUS_MISC)
                            {
                                // Misc Bonus
                                nAttackBonus += GetEffectInteger(eCheck, 0);
                            }
                            // Catches just specific bonuses
                            else if(nValue == nAttackBonus)
                            {
                                // Set bonus if higher
                                nValue = GetEffectInteger(eCheck, 0);
                                if(nValue > nWeaponBonus) nWeaponBonus = nValue;
                            }
                        }
                    }
                }
            }
        }
        else if(nValue == EFFECT_TYPE_ATTACK_DECREASE)
        {
            // Check race etc.
            nValue = GetEffectInteger(eCheck, 2);
            if(nValue == RACIAL_TYPE_INVALID ||
               nValue == nRace)
            {
                // Alignment Law/Chaos
                nValue = GetEffectInteger(eCheck, 3);
                if(nValue == ALIGNMENT_ALL ||
                   nValue == nLawChaos)
                {
                    // Alignment Good/Evil
                    nValue = GetEffectInteger(eCheck, 4);
                    if(nValue == ALIGNMENT_ALL ||
                       nValue == nGoodEvil)
                    {
                        // Attack bonus type (misc or specific)
                        nValue = GetEffectInteger(eCheck, 1);
                        if(nValue == nAttackBonus || nValue == ATTACK_BONUS_MISC)
                        {
                            // All misc bonuses are added
                            if(nValue == ATTACK_BONUS_MISC)
                            {
                                // Misc Penalty
                                nAttackPenalty += GetEffectInteger(eCheck, 0);
                            }
                            // Catches just specific bonuses
                            else if(nValue == nAttackBonus)
                            {
                                // Set penalty if higher
                                nValue = GetEffectInteger(eCheck, 0);
                                if(nValue > nWeaponPenalty) nWeaponPenalty = nValue;
                            }
                        }
                    }
                }
            }
        }
        else if(nValue == EFFECT_TYPE_ENTANGLE)
        {
            // Entangle has a -2 misc attack penalty
            nAttackPenalty += 2;
        }
        else if(nValue == EFFECT_TYPE_NEGATIVELEVEL)
        {
            // Negative Levels apply -1 per negative level
            nAttackPenalty += GetEffectInteger(eCheck, 0);
        }
        else if(nValue == EFFECT_TYPE_HASTE)
        {
            nHasteSlow++;
        }
        else if(nValue == EFFECT_TYPE_SLOW)
        {
            nHasteSlow--;
        }
        eCheck = GetNextEffect(oCreature);
    }

    // Haste and Slow
    if(nHasteSlow > 0)
    {
        nAttackBonus += 2;
    }
    else if(nHasteSlow < 0)
    {
        nAttackPenalty += 2;
    }

    // Cap bonuses and penalties
    int nCap = GetAttackBonusLimit();

    // Total it kinda
    nAttackBonus += nWeaponBonus;
    nAttackPenalty += nWeaponPenalty;

    // Seems the game caps both, and then takes one from the other.
    // A +30 weapon with a -10 penalty goes to +10 only if cap is default 20.
    if(nAttackBonus > nCap) nAttackBonus = nCap;
    if(nAttackPenalty > nCap) nAttackPenalty = nCap;

    return nAttackBonus - nAttackPenalty;
}


// This will return the amount of change in the given attack for for EffectAttackIncrease or
// EffectAttackDecrease
// - eAttackEffect - an Attack Increase or Attack Decrease effect
// * Returns -1 on error
int GetEffectAttackChangeAmount(effect eAttackEffect)
{
    if(GetEffectType(eAttackEffect) != EFFECT_TYPE_ATTACK_INCREASE &&
       GetEffectType(eAttackEffect) != EFFECT_TYPE_ATTACK_DECREASE) return -1;
    return GetEffectInteger(eAttackEffect, 0);
}

// This will return the ATTACK_BONUS_* type for EffectAttackIncrease or
// EffectAttackDecrease (although only increase can have it specified in scripts).
// - eAttackEffect - an Attack Increase or Attack Decrease effect
// * Returns -1 on error
int GetEffectAttackChangeBonusType(effect eAttackEffect)
{
    if(GetEffectType(eAttackEffect) != EFFECT_TYPE_ATTACK_INCREASE &&
       GetEffectType(eAttackEffect) != EFFECT_TYPE_ATTACK_DECREASE) return -1;
    return GetEffectInteger(eAttackEffect, 1);
}

// This will get the movement speed increase of the given effect
// Do this calculation to get the final change: IntToFloat(Return Value)/100.0
// 150 = * 1.5 speed
// 110 = * 1.1 speed
// - eEffect - Effect to check
// * Returns 0 on error
int GetEffectMovementSpeedIncreaseAmount(effect eEffect)
{
    if(GetEffectType(eEffect) != EFFECT_TYPE_MOVEMENT_SPEED_DECREASE) return 0;
    return GetEffectInteger(eEffect, 0);
}

// This will get the movement speed increase of the given effect
// Do this calculation to get the final change: 1.0 - IntToFloat(Return Value)/100.0
// 50 = * 0.5 speed
// 80 = * 0.2 speed
// - eEffect - Effect to check
// * Returns 0 on error
int GetEffectMovementSpeedDecreaseAmount(effect eEffect)
{
    if(GetEffectType(eEffect) != EFFECT_TYPE_MOVEMENT_SPEED_DECREASE) return 0;
    return GetEffectInteger(eEffect, 0);
}

// This will total up the multipliers of speed changes applied to oTarget.
// The cap is 0.125 minimum and 1.5 maximum (except people with 3 or more Monk levels, where it is 3.0 maximum).
// This is then multiplied to whatever usual rate of movement the
//
// There are some known bugs, see: https://nwnlexicon.com/index.php?title=EffectMovementSpeedDecrease#Effect_Breakdown
// Run FixMovementSpeedEffectsModifiers() after applying a new effect to get a proper fixed total.
// * oCreature - Creature to check effects of
float GetTotalMovementSpeedEffectsModifier(object oCreature)
{
    float fSpeed = 1.0;

    // Multiply as we go along
    // Remove it immediately
    effect eCheck = GetFirstEffect(oCreature);
    int nType, nHasteSlow = 0;
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);
        if(nType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)
        {
            // Example:
            // nPercentIncrease = 250 -> 2.5, multiply by 2.5 (250% change)
            // nPercentIncrease = -150 -> -1.5, multiply by -1.5 (-150% change)
            fSpeed *= IntToFloat(GetEffectInteger(eCheck, 0)) / 100.0;
        }
        else if(nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
        {
            // Example:
            // nPercentDecrease = 80 -> 0.8, 1.0 - 0.8, multiply by 0.2 (20% of total)
            // nPercentDecrease = -80 -> -0.8, 1.0 - -0.8, multiply 1.8 (80% increase)
            fSpeed *= (1.0 - (IntToFloat(GetEffectInteger(eCheck, 0)) / 100));
        }
        else if(nType == EFFECT_TYPE_HASTE)
        {
            nHasteSlow++;
        }
        else if(nType == EFFECT_TYPE_SLOW)
        {
            nHasteSlow--;
        }
        eCheck = GetNextEffect(oCreature);
    }

    // Haste * 1.5, slow reduces it by 0.5
    if(nHasteSlow > 0)
    {
        fSpeed *= 1.5;
    }
    else if(nHasteSlow < 0)
    {
        fSpeed *= 0.5;
    }

    // Cap at end
    if(fSpeed > 3.0 && GetLevelByClass(CLASS_TYPE_MONK, oCreature) >= 3) fSpeed = 3.0;
    if(fSpeed > 1.5 && GetLevelByClass(CLASS_TYPE_MONK, oCreature) < 3) fSpeed = 1.5;
    if(fSpeed < 0.125) fSpeed = 0.125;

    return fSpeed;
}

// This will apply a 100 speed increase (which has no effect) and immediately remove it. Once removed
// the speed increases and decreases get recalculated.
void FixMovementSpeedEffectsModifiers(object oCreature)
{
    // 100 = no change.
    effect eSpeed = TagEffect(EffectMovementSpeedIncrease(100), "FIX");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oCreature, 0.1);

    // Remove it immediately
    effect eCheck = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE &&
           GetEffectTag(eCheck) == "FIX" &&
           GetEffectInteger(eCheck, 0) == 100)
        {
            RemoveEffect(oCreature, eSpeed);
        }
        eCheck = GetNextEffect(oCreature);
    }
}

// This function is currently INCOMPLETE and may have some issues being a true fully working function.
// This will return the total saving throw bonus with a given saving throw type and if it is a spell
// adds on the spellcraft save bonus.
// - nSave - SAVING_THROW_* eg SAVING_THROW_WILL
// - oObject - The object to get saving throw of (Creature, Door, Placeable)
// - Opponent - If present will be used for race/alignement specific saving throw bonuses
// - nSaveType - SAVING_THROW_TYPE_* value, eg: SAVING_THROW_TYPE_FIRE
// - bSpell - If TRUE will also assume nSaveType adds SAVING_THROW_TYPE_SPELL
//     SAVING_THROW_TYPE_SPELL adds spell-specific saves but also a bonus from spellcraft.
// * Returns -100 on error (should always fail that save!)
int GetEffectSavingThrowBonuses(int nSave, object oObject, object oOpponent = OBJECT_INVALID, int nSaveType = SAVING_THROW_TYPE_NONE, int bSpell = FALSE)
{
    if(!GetIsObjectValid(oObject)) return -100;

    // The different bonuses we calculate
    int nBaseSave;

    // Check the specific save
    // This does:
    // * Base stats
    // * Misc effect bonuses (as if SAVING_THROW_TYPE_NONE)
    // * Feats
    switch(nSave)
    {
        case SAVING_THROW_FORT:   nBaseSave = GetFortitudeSavingThrow(oObject); break;
        case SAVING_THROW_REFLEX: nBaseSave = GetReflexSavingThrow(oObject); break;
        case SAVING_THROW_WILL:   nBaseSave = GetWillSavingThrow(oObject); break;
        default: return -100; break;
    }

    // If invalid opponent and no save type or spell we just return the above
    if(!GetIsObjectValid(oOpponent) &&  nSaveType == SAVING_THROW_TYPE_NONE && bSpell == FALSE)
    {
        return nBaseSave;
    }

    // Other variables used for specific vs. type or vs. alignment etc.
    int nSavePenalty, nSaveBonus;
    int x, nValue;
    int nRace = GetRacialType(oOpponent);
    int nGoodEvil = GetAlignmentGoodEvil(oOpponent);
    int nLawChaos = GetAlignmentLawChaos(oOpponent);

    // We need vs. specific saves on items first
    if(nSaveType != SAVING_THROW_TYPE_NONE && bSpell == FALSE)
    {
        int nSubtype;
        object oItem;
        itemproperty ip;

        // Convert the item property subtype we need. Annoyingly not the same as the SAVING_THROW_TYPE_* constants
        int nItemSubtypeNeeded = -1;
        switch(nSaveType)
        {
            case SAVING_THROW_TYPE_ACID:        nItemSubtypeNeeded = 1; break;
            case SAVING_THROW_TYPE_CHAOS:       nItemSubtypeNeeded = 19; break;
            case SAVING_THROW_TYPE_COLD:        nItemSubtypeNeeded = 3; break;
            case SAVING_THROW_TYPE_DEATH:       nItemSubtypeNeeded = 4; break;
            case SAVING_THROW_TYPE_DISEASE:     nItemSubtypeNeeded = 5; break;
            case SAVING_THROW_TYPE_DIVINE:      nItemSubtypeNeeded = 6; break;
            case SAVING_THROW_TYPE_ELECTRICITY: nItemSubtypeNeeded = 7; break;
            case SAVING_THROW_TYPE_EVIL:        nItemSubtypeNeeded = 21; break;
            case SAVING_THROW_TYPE_FEAR:        nItemSubtypeNeeded = 8; break;
            case SAVING_THROW_TYPE_FIRE:        nItemSubtypeNeeded = 9; break;
            case SAVING_THROW_TYPE_GOOD:        nItemSubtypeNeeded = 20; break;
            case SAVING_THROW_TYPE_LAW:         nItemSubtypeNeeded = 18; break;
            case SAVING_THROW_TYPE_MIND_SPELLS: nItemSubtypeNeeded = 11; break;
            case SAVING_THROW_TYPE_NEGATIVE:    nItemSubtypeNeeded = 12; break;
            case SAVING_THROW_TYPE_POISON:      nItemSubtypeNeeded = 13; break;
            case SAVING_THROW_TYPE_POSITIVE:    nItemSubtypeNeeded = 14; break;
            case SAVING_THROW_TYPE_SONIC:       nItemSubtypeNeeded = 15; break;
            case SAVING_THROW_TYPE_SPELL:       nItemSubtypeNeeded = 17; break;
            case SAVING_THROW_TYPE_TRAP:        nItemSubtypeNeeded = 16; break;
        }
        // Not finding anything is fine, since it might default to spells only.

        // Spells "constant"
        int nSpellsItemSubtype = 17;

        // Equipped items first
        for(x = 0; x < NUM_INVENTORY_SLOTS; x++)
        {
            oItem = GetItemInSlot(x, oObject);
            if(GetIsObjectValid(oItem))
            {
                // Check item properties
                ip = GetFirstItemProperty(oItem);
                while(GetIsItemPropertyValid(ip))
                {
                    // We only need to check for SPECIFIC saving throw bonuses, since ITEM_PROPERTY_DECREASED_SAVING_THROWS is already accounted for
                    // There is no "vs. Alignment/Race" for item effects, but the SPECIFIC saving throws apply to every save type (fortitude, reflex, will)
                    switch(GetItemPropertyType(ip))
                    {
                        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
                        {
                            nSubtype = GetItemPropertySubType(ip);
                            // Note by default nSubtype can't be SAVING_THROW_TYPE_SPELL (it's not in iprp_saveelement.2da) but
                            // it's here for future proofing / does no harm
                            if(nSubtype == nSaveType || (bSpell && nSubtype == nSpellsItemSubtype))
                            {
                                nSavePenalty += GetItemPropertyCostTableValue(ip);
                            }
                        }
                        break;
                        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
                        {
                            nSubtype = GetItemPropertySubType(ip);
                            // Note by default nSubtype can't be SAVING_THROW_TYPE_SPELL (it's not in iprp_saveelement.2da) but
                            // it's here for future proofing / does no harm
                            if(nSubtype == nSaveType || (bSpell && nSubtype == nSpellsItemSubtype))
                            {
                                nSaveBonus += GetItemPropertyCostTableValue(ip);
                            }
                        }
                        break;
                    }
                    ip = GetNextItemProperty(oItem);
                }
            }
        }
    }

    // Effects that affect saves:
    // * Bonuses/penalties to base saves - we just ones matching alignment however (other misc ones accounted for)
    // * Bonuses/penalties to specific save types - eg vs. Fire
    // * Negative levels (-1 per level) (already accounted for)
    effect eCheck = GetFirstEffect(oObject);
    while(GetIsEffectValid(eCheck))
    {
        switch(GetEffectType(eCheck))
        {
            case EFFECT_TYPE_SAVING_THROW_INCREASE:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            {
                // Correct base type of save
                nValue = GetEffectInteger(eCheck, 1);
                if(nValue == SAVING_THROW_ALL || nValue == nSave)
                {
                    // Correct specific save type, or all
                    nValue = GetEffectInteger(eCheck, 2);
                    if(nValue == SAVING_THROW_TYPE_ALL || nValue == nSaveType || (bSpell && nValue == SAVING_THROW_TYPE_SPELL))
                    {
                        // Check race etc.
                        nValue = GetEffectInteger(eCheck, 3);
                        if(nValue == RACIAL_TYPE_INVALID ||
                           nValue == nRace)
                        {
                            // Alignment Law/Chaos
                            nValue = GetEffectInteger(eCheck, 4);
                            if(nValue == ALIGNMENT_ALL ||
                               nValue == nLawChaos)
                            {
                                // Alignment Good/Evil
                                nValue = GetEffectInteger(eCheck, 5);
                                if(nValue == ALIGNMENT_ALL ||
                                   nValue == nGoodEvil)
                                {
                                    // All matches so we add/remove the bonus
                                    if(GetEffectType(eCheck) == EFFECT_TYPE_SAVING_THROW_INCREASE)
                                    {
                                        nSaveBonus += GetEffectInteger(eCheck, 0);
                                    }
                                    else
                                    {
                                        nSavePenalty += GetEffectInteger(eCheck, 0);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            break;
        }
        eCheck = GetNextEffect(oObject);
    }

    // Bonus from spellcraft
    int nSpellcraftBonus = 0;
    if(bSpell || nSaveType == SAVING_THROW_TYPE_SPELL)
    {
        // No bonuses without ranks
        if(GetHasSkill(SKILL_SPELLCRAFT, oObject))
        {
            // Get total skill plus specific bonus versus the target
            int nSkill = GetSkillRank(SKILL_SPELLCRAFT, oObject);
            // Increase with specific bonuses vs. alignment etc.
            // TODO

            if(nSkill > 0)
            {
                // Bonus calculation using ruleset.2da value
                nSpellcraftBonus = nSkill / StringToInt(Get2DAString("ruleset", "Value", 197));
            }
        }
    }

    // Cap bonuses and penalties
    int nCap = GetSavingThrowBonusLimit();

    // This isn't perfect since we can't actually get the base-base saving throw...urg.
    if(nSaveBonus > nCap) nSaveBonus = nCap;
    if(nSavePenalty > nCap) nSavePenalty = nCap;

    return nSave + nSaveBonus - nSavePenalty + nSpellcraftBonus;
}