Q = require "q"
childProcess = require('child_process')
###########################################################################

module.exports = (deployment, workingDirectory) ->
  deferred = Q.defer()
  if deployment.hosts? && deployment.hosts isnt ""
    deployCommand = "fab -H #{deployment.hosts} #{deployment.task}:branch_name=#{deployment.ref} --set=environment=#{deployment.env}"
  else
    deployCommand = "fab -R #{deployment.env} #{deployment.task}:branch_name=#{deployment.ref} --set=environment=#{deployment.env}"

  console.log("Executing fabric: #{deployCommand}")

  childProcess.exec(deployCommand,{cwd:workingDirectory}, (error, stdout, stderr) ->
    if error? && error isnt ""
      deferred.reject({error, stdout, stderr})
    else
      deferred.resolve({error, stdout, stderr})
  )

  return deferred.promise
