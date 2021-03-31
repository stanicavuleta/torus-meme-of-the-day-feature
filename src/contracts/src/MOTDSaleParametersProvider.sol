// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MOTDSaleParametersProvider
 * @notice A contract which holds all parameters necessary to calculate fees during sale
 * @author MemeOfTheDay
 */
contract MOTDSaleParametersProvider is Ownable {
    uint256 public constant DEFAULT_CREATOR_FEE_PERCENT_INDEX = 0;
    uint256 public constant VOTERS_FEE_PERCENT_INDEX = 1;
    uint256 public constant PLATFORM_FEE_PERCENT_INDEX = 2;
    uint256 public constant TOTAL_FEES_PERCENT_INDEX = 3;

    mapping(uint256 => uint256) public parameters;

    // Here percents are expressed as perthousands, since in Solidity float numbers don't exist
    constructor() public {
        parameters[DEFAULT_CREATOR_FEE_PERCENT_INDEX] = 100; // 10% (default) or custom% set by creator when minting
        parameters[VOTERS_FEE_PERCENT_INDEX] = 5; // 0.5%
        parameters[PLATFORM_FEE_PERCENT_INDEX] = 19; // 1.9%
        parameters[TOTAL_FEES_PERCENT_INDEX] =
            parameters[VOTERS_FEE_PERCENT_INDEX] +
            parameters[PLATFORM_FEE_PERCENT_INDEX];
    }

    /**
     * @notice Changes one of the parameters with the given value
     * @param paramIndex the index of the parameter in the mapping
     * @param paramValue the new value to set to that parameter
     */
    function changeParameter(uint256 paramIndex, uint256 paramValue)
        external
        onlyOwner
    {
        require(
            paramIndex <= 2,
            "Invalid parameter index: must be less or equal to 2" // must be less than 3 because TOTAL_FEES_PERCENT is always derived, can't be set directly
        );
        parameters[paramIndex] = paramValue;

        if (
            paramIndex == VOTERS_FEE_PERCENT_INDEX ||
            paramIndex == PLATFORM_FEE_PERCENT_INDEX
        ) {
            parameters[TOTAL_FEES_PERCENT_INDEX] =
                parameters[VOTERS_FEE_PERCENT_INDEX] +
                parameters[PLATFORM_FEE_PERCENT_INDEX];
        }
    }
}
