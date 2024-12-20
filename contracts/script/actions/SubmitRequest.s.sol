// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

import {GlobalTypes} from "../../src/libraries/GlobalTypes.sol";
import {RIP7755Outbox} from "../../src/RIP7755Outbox.sol";
import {CrossChainRequest, Call} from "../../src/RIP7755Structs.sol";

contract SubmitRequest is Script {
    using GlobalTypes for address;

    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        RIP7755Outbox outbox = RIP7755Outbox(0xBCd5762cF9B07EF5597014c350CE2efB2b0DB2D2);

        CrossChainRequest memory request = _getRequest();

        vm.startBroadcast(pk);
        outbox.requestCrossChainCall{value: request.rewardAmount}(request);
        vm.stopBroadcast();
    }

    function _getRequest() private pure returns (CrossChainRequest memory) {
        return CrossChainRequest({
            requester: 0x328809Bc894f92807417D2dAD6b7C998c1aFdac6.addressToBytes32(),
            calls: new Call[](0),
            sourceChainId: 11155420,
            origin: 0x49E2cDC9e81825B6C718ae8244fe0D5b062F4874.addressToBytes32(), // RIP7755Inbox on Optimism Sepolia
            destinationChainId: 11155420,
            inboxContract: 0x49E2cDC9e81825B6C718ae8244fe0D5b062F4874.addressToBytes32(), // RIP7755Inbox on Optimism Sepolia
            l2Oracle: 0x218CD9489199F321E1177b56385d333c5B598629.addressToBytes32(), // Anchor State Registry on Sepolia
            rewardAsset: 0x2e234DAe75C793f67A35089C9d99245E1C58470b.addressToBytes32(),
            rewardAmount: 1 ether,
            finalityDelaySeconds: 10,
            nonce: 1,
            expiry: 1828828574,
            extraData: new bytes[](0)
        });
    }
}
