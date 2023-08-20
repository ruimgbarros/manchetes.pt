const { BskyAgent, RichText } = require("@atproto/api");
const sharp = require("sharp");

const data = require('./apublicar.json');



async function sendPost(text, link, image_url, description) {
    const agent = new BskyAgent({ service: "https://bsky.social" });
    await agent.login({
      identifier: process.env.BSKY_HANDLE,
      password: process.env.BSKY_PASSWORD,
    });
    const richText = new RichText({ text });
    await richText.detectFacets(agent);

        const buffer = await fetch(image_url)
        .then((response) => response.arrayBuffer())
        .then((buffer) => sharp(buffer))
        .then((s) =>
        s.resize(
            s
            .resize(800, null, {
                fit: "inside",
                withoutEnlargement: true,
            })
            .jpeg({
                quality: 80,
                progressive: true,
            })
            .toBuffer()
        )
        );

    const image = await agent.uploadBlob(buffer, { encoding: "image/jpeg" });

    await agent.post({
        text: richText.text,
        facets: richText.facets,
        createdAt: new Date().toISOString(),
        embed: {
            $type: 'app.bsky.embed.external',
            external: {
                uri: link,
                title: text,
                description: description,
                thumb: image.data.blob
              }
        }
    });
  }


sendPost(data[0].titulo, data[0].link, data[0].thumb, data[0].desc);
