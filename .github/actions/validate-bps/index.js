//import {context, GitHub} from '@actions/github'

const core = require('@actions/core');
// const { GitHub } = require('@actions/github');
const github = require("@actions/github");
let { context } = require('@actions/github');
const fs = require('fs');
const path = require('path');
const fetch = require("node-fetch");

async function run() {
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
        const response = await client.repos.compareCommits({
            base,
            head,
            owner: context.repo.owner,
            repo: context.repo.repo
        })

        core.info(response)
        // Ensure that the request was successful.
        if (response.status !== 200) {
            core.setFailed(
                `The GitHub API for comparing the base and head commits for this ${context.eventName} event returned ${response.status}, expected 200. ` +
                "Please submit an issue on this action's GitHub repo."
            )
        }

        let branch;
        if ('pull_request' in github.context.payload) {
            branch = 'pull/' + github.context.payload.number + '/head';
        }
        else if ('ref' in github.context.payload) {
            const arr = github.context.payload.ref.split("/");
            branch = arr[arr.length - 1];        
        }
        else {
            core.setFailed('Unable to fetch branch due to unsupported event');
        }
        let bps = []
        // Get the changed files from the response payload.
        const files = response.data.files
        for (const file of files) {
            if (file.status === "removed") {
                continue
            }
            const filename = file.filename
            core.info(`Found change in file ${filename}`)

            if (filename.startsWith('blueprints/')) {
                var bp_name = filename.replace('blueprints/', '').replace('.yaml', '')
                // bps.push()
                const data = {
                    'blueprint_name': bp_name,
                    'source': {
                        'branch': branch
                        // todo - add commit
                    }
                }

                fetch(`https://cloudshellcolony.com/api/spaces/${space}/validations/blueprints`, {
                    method: 'POST',
                    cache: 'no-cache', 
                    headers: {
                        "Content-Type": "application/json",
                        "Authorization": `Bearer ${token}`
                    },
                    body: JSON.stringify(data)
                })
                    .then(response => { return response.json() })
                    .then(data => {
                        // Work with JSON data here
                        logger.debug(`response json data: ${JSON.stringify(data)}`);
                        if ('errors' in data && data.errors && data.errors.length > 0) {
                            logger.error(`validation for blueprint "${data.blueprint_name} failed"`)
                            throw JSON.stringify({'blueprint_name': data.blueprint_name, 'errors': data.errors});
                        }
                    })
                    .catch(error => core.setFailed(error));

                
            } else{
                continue
            }
        }
    } catch (error) {
        core.setFailed(error.message)
    }
}
run();