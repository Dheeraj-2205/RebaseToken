


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RebaseToken is ERC20 {
    error RebaseToken_InterestRateCanOnlyDecrease(uint256 oldInterestRate, uint256 newInterestRate);
    uint256 private s_interestRate = 5e10;
    uint256 constant PRECISION_FACTOR = 1e18;
    mapping (address => uint256) private s_userInterestRate;
    mapping (address => uint256) private s_userLastUpdatedTimeStamp;

    event InterestRateSet(uint256 newInterestRate);
    constructor() ERC20 ("Rebase Token" , "RBT") {}

    function setInterestRate(uint256 _newInterestRate) external {
        if(_newInterestRate < s_interestRate) {
            revert RebaseToken_InterestRateCanOnlyDecrease(s_interestRate, _newInterestRate);
        }
        s_interestRate = _newInterestRate;
        emit InterestRateSet(_newInterestRate);
    }

    function mint(address _to, uint256 _amount) external {
        _mintAccurateInterest(_to);
        s_userInterestRate[_to] = s_interestRate;
        _mint(_to, _amount);
    }

    function burn (address _from , uint256 _amount) external {
        if(_amount > type(uint256).max) {
            _amount = balanceOf(_from);
        }
        _mintAccurateInterest(_from);
        _burn(_from, _amount);
    }



    function balanceOf(address _user) public view override returns (uint256){
        return super.balanceOf(_user) * _calculateUserAccumulatedInterestSinceLastUpdated(_user) / PRECISION_FACTOR;


    }

    function _calculateUserAccumulatedInterestSinceLastUpdated(address _user) internal view returns (uint256 linearInterest){
        uint256 timeElapsed = block.timestamp - s_userLastUpdatedTimeStamp[_user];
        linearInterest = (PRECISION_FACTOR + (s_userInterestRate[_user] * timeElapsed));
    }

    function _mintAccurateInterest(address _user) internal {  
        uint256 previousPrincipalBalance = super.balanceOf(_user);
        uint256 currentBalance = balanceOf(_user);
        uint256 balanceIncrease = currentBalance - previousPrincipalBalance;

        s_userLastUpdatedTimeStamp[_user] = block.timestamp;

        _mint(_user , balanceIncrease);

    }

    function getUserInterestRate(address _user) external view returns (uint256) {
        return s_userInterestRate[_user];
    }

}