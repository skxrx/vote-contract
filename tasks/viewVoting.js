const { task } = require('hardhat/config')

task('viewVoting', 'View voting')
  .addParam('votingId', 'Id of voting you want to end')
  .setAction(async (taskArgs) => {
    const Voting = await ethers.getContractFactory('Vote')
    await Voting.viewVoting(taskArgs.votingId)
    const result = await Voting.viewVoting(taskArgs.votingId)
    console.log(`Voting results: ${result}`)
  })
