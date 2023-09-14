"use strict";

async function unsubscribe(email, reason) {
  await fetch("https://internal.exercism.org/spi/unsubscribe_user", {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ email, reason }),
  });
}

async function unsubscribeRecipients(recipients, reason) {
  if (recipients === null || recipients === undefined) return;

  await Promise.all(
    recipients.map((recipient) => unsubscribe(recipient.emailAddress, reason))
  );
}

async function processRecord(record) {
  const message = JSON.parse(record.Sns.Message);
  if (message.eventType === "Bounce")
    await unsubscribeRecipients(message.bounce.bouncedRecipients, "bounce");
  else if (message.eventType === "Complaint")
    await unsubscribeRecipients(message.bounce.complainedRecipients, "complaint");
}

exports.handler = async (event, context) => {
  await Promise.all(event.Records.map((record) => processRecord(record)));
};
