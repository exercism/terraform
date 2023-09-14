"use strict";

async function unsubscribe(email) {
  console.log("EMAIL: " + email)
  await fetch("https://internal.exercism.org/spi/unsubscribe_user", {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email }),
  });
}

async function unsubscribeRecipients(recipients) {
  if (recipients === null || recipients === undefined) return;

  await Promise.all(
    recipients.map((recipient) => unsubscribe(recipient.emailAddress))
  );
}

async function processRecord(record) {
  const message = JSON.parse(record.Sns.Message);
  if (message.eventType === "Bounce")
    await unsubscribeRecipients(message.bounce.bouncedRecipients);
  else if (message.eventType === "Complaint")
    await unsubscribeRecipients(message.bounce.complainedRecipients);
}

exports.handler = async (event, context) => {
  await Promise.all(event.Records.map((record) => processRecord(record)));
};
