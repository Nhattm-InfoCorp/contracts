pragma solidity ^0.4.16;

contract ValidatorSetGetter {
	/// Get current validator set (last enacted or initial if no changes ever made)
	function getValidators() public constant returns (address[]);
}

contract ValidatorSet is ValidatorSetGetter {
	/// Issue this log event to signal a desired change in validator set.
	/// This will not lead to a change in active validator set until
	/// finalizeChange is called.
	///
	/// Only the last log event of any block can take effect.
	/// If a signal is issued while another is being finalized it may never
	/// take effect.
	///
	/// parentHash here should be the parent block hash, or the
	/// signal will not be recognized.
	event InitiateChange(bytes32 indexed parentHash, address[] newSet);

	/// Called when an initiated change reaches finality and is activated.
	/// Only valid when msg.sender == SYSTEM (EIP96, 2**160 - 2)
	///
	/// Also called when the contract is first enabled for consensus. In this case,
	/// the "change" finalized is the activation of the initial set.
	function finalizeChange() public;

	// Reporting functions: operate on current validator set.
	// malicious behavior requires proof, which will vary by engine.

	function reportBenign(address validator, uint256 blockNumber) public;
	function reportMalicious(address validator, uint256 blockNumber, bytes proof) public;
}

contract SafeValidatorSet is ValidatorSet {
	function reportBenign(address, uint256) public {}
	function reportMalicious(address, uint256, bytes) public {}
}

contract ImmediateSet is ValidatorSet {
	function finalizeChange() public {}
}
