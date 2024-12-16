// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {Errors} from '../../src/contracts/protocol/libraries/helpers/Errors.sol';
import {UserConfiguration} from '../../src/contracts/protocol/libraries/configuration/UserConfiguration.sol';
import {Testhelpers, IERC20} from './Testhelpers.sol';

/**
 * Scenario suite for pool getter operations.
 */
contract PoolGetters_gas_Tests is Testhelpers {
  // mock users to supply and borrow liquidity
  address user = makeAddr('user');

  function test_getReserveData() external {
    contracts.poolProxy.getReserveData(tokenList.usdx);
    vm.snapshotGasLastCall('Pool.Getters', 'getReserveData');
  }

  function test_getUserAccountData() external {
    contracts.poolProxy.getUserAccountData(user);
    vm.snapshotGasLastCall('Pool.Getters', 'getUserAccountData: supplies: 0, borrows: 0');
  }

  function test_getUserAccountData_oneSupplies() external {
    _supplyOnReserve(user, 1 ether, tokenList.usdx);
    contracts.poolProxy.getUserAccountData(user);
    vm.snapshotGasLastCall('Pool.Getters', 'getUserAccountData: supplies: 1, borrows: 0');
  }

  function test_getUserAccountData_twoSupplies() external {
    _supplyOnReserve(user, 1 ether, tokenList.usdx);
    _supplyOnReserve(user, 1 ether, tokenList.weth);

    contracts.poolProxy.getUserAccountData(user);
    vm.snapshotGasLastCall('Pool.Getters', 'getUserAccountData: supplies: 2, borrows: 0');
  }

  function test_getUserAccountData_twoSupplies_oneBorrows() external {
    _supplyOnReserve(user, 1 ether, tokenList.usdx);
    _supplyOnReserve(user, 1 ether, tokenList.weth);

    _supplyOnReserve(address(1), 0.001e8, tokenList.wbtc);
    vm.prank(user);
    contracts.poolProxy.borrow(tokenList.wbtc, 0.001e8, 2, 0, user);

    contracts.poolProxy.getUserAccountData(user);
    vm.snapshotGasLastCall('Pool.Getters', 'getUserAccountData: supplies: 2, borrows: 1');
  }

  function test_getEModeCategoryData() external {
    contracts.poolProxy.getEModeCategoryData(1);
    vm.snapshotGasLastCall('Pool.Getters', 'getEModeCategoryData');
  }

  function test_getEModeCategoryCollateralConfig() external {
    contracts.poolProxy.getEModeCategoryCollateralConfig(1);
    vm.snapshotGasLastCall('Pool.Getters', 'getEModeCategoryCollateralConfig');
  }

  function test_getLiquidationGracePeriod() external {
    contracts.poolProxy.getLiquidationGracePeriod(tokenList.usdx);
    vm.snapshotGasLastCall('Pool.Getters', 'getLiquidationGracePeriod');
  }
}