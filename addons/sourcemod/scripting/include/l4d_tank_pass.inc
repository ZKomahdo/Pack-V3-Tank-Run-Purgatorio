/** Double-include prevention */
#if defined _mynatives_included_
  #endinput
#endif
#define _mynatives_included_

/**
 * Change player Tank to another target player
 *
 * @param num1    target tank player.
 * @param num2    target client to play as tank.
 */
native void TS_TankPass(int iClientOld, int iClientNew);
