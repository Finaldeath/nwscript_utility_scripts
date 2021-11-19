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