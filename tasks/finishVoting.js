const { task } = require('hardhat/config')

task('finishVoting', 'Finish voting')
  .addParam('votingId', 'Id of voting you want to end')
  .setAction(async (taskArgs) => {
    const Voting = await ethers.getContractFactory('Vote')
    await Voting.finishVoting(taskArgs.VotingId)
    const result = await Voting.finishVoting(taskArgs.votingId)
    console.log(`Voting results: ${result}`)
  })
