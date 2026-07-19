// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {TokenPool} from "@ccip/contracts/pools/TokenPool.sol";
import {Pool} from "@ccip/contracts/libraries/Pool.sol";


contract RebaseTokenPool is TokenPool {
    constructor(IERC20 _token ,address[] memory _allowList, address _rawProxy, address _router) 
        TokenPool(_token, _allowList, _rawProxy, _router)
    {

    }

    function lockOrBurn(Pool.LockOrBurnInV1 calldata lockOrnBurnIn) 
        external  returns (Pool.LockOrBurnOutV1 memory lockOrBurnOut)
    {
        _validateLockOrBurn(lockOrBurnIn);
    }

    function releaseOrMint(Pool.ReleaseOrMintInV1 calldata releaseOrMintIn) 
        external returns (Pool.ReleaseOrMintOutV1 memory){
    }

}