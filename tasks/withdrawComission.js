const { task } = require('hardhat/config')

task('withdrawComission', 'Withdraw comission to owner')
  .addParam('votingId', 'Voting Id from which you want to withdraw comission')
  .setAction(async (taskArgs) => {
    const Voting = await ethers.getContractFactory('Vote')
    await Voting.withdrawComission(taskArgs.votingId)
    console.log(`Commission has been withdrawed from votingId: ${taskArgs.votingId}`)
  })
