const { BskyAgent, RichText } = require("@atproto/api");

const agent = new BskyAgent({ service: "https://bsky.social" });
    await agent.login({
      identifier: process.env.BSKY_HANDLE,
      password: process.env.BSKY_PASSWORD,
    });
