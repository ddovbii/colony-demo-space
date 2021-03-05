//import {context, GitHub} from '@actions/github'

const core = require('@actions/core');
// const { GitHub } = require('@actions/github');
const github = require("@actions/github");
let { context } = require('@actions/github');


try {
    // const logger = new Logger(core.getInput('debug'))
    const token = core.getInput('token');
    const gh_token = core.getInput('github_token')
    const space = core.getInput('space');
    const client = github.getOctokit(gh_token);
    
    const eventName = context.eventName

    switch (eventName) {
        case 'pull_request':
            base = context.payload.pull_request.base.sha
            head = context.payload.pull_request.head.sha
            break
        case 'push':
            base = context.payload.before
            head = context.payload.after
            break
        default:
            core.setFailed(
                `This action only supports pull requests and pushes, ${context.eventName} events are not supported. ` +
               "Please submit an issue on this action's GitHub repo if you believe this in correct."
            )
    }

    // Log the base and head commits
    core.info(`Base commit: ${base}`)
    core.info(`Head commit: ${head}`)

    // Ensure that the base and head properties are set on the payload.
    if (!base || !head) {
        core.setFailed(
            `The base and head commits are missing from the payload for this ${context.eventName} event. ` +
            "Please submit an issue on this action's GitHub repo."
        )

        // To satisfy TypeScript, even though this is unreachable.
        base = ''
        head = ''
    }

    // Use GitHub's compare two commits API.
    // https://developer.github.com/v3/repos/commits/#compare-two-commits
    const response = client.repos.compareCommits({
        base,
        head,
        owner: context.repo.owner,
        repo: context.repo.repo
    })

    coro.info(response)
    // Ensure that the request was successful.
    if (response.status !== 200) {
        core.setFailed(
            `The GitHub API for comparing the base and head commits for this ${context.eventName} event returned ${response.status}, expected 200. ` +
            "Please submit an issue on this action's GitHub repo."
        )
    }
    // Get the changed files from the response payload.
    const files = response.data.files
    for (const file of files) {
        const filename = file.filename

        if (file.status === "removed") {
            continue
        }
       
        // Alex's code is starting here
    }
} catch (error) {
    core.setFailed(error.message)
}