⚡ TL;DR — Right Flow

Create IAM users → add them to a group

Create the target role with the policies that define what actions are allowed

Set the trust policy on the role to allow specific users (or all users in the account) to assume the role

Attach a policy to the group allowing sts:AssumeRole on the role → users inherit ability to assume

Users assume the role → get temporary credentials

 **********************************************************************************************************************************************************************************************************

1️⃣ Two Separate Things Are Happening

A. Role’s Trust Policy

The trust policy of the role defines who is allowed to assume the role at all.

It is enforced by AWS when sts:AssumeRole is called.

Only the principals listed in the trust policy can successfully assume the role.

Example: If you list users alice and bob in the trust policy, no one else can assume the role, even if they have sts:AssumeRole permission attached.

B. sts:AssumeRole Permission Policy

This is a policy you attach to users or a group that grants them permission to call the sts:AssumeRole API.

Without this permission, even if the user is in the role’s trust policy, AWS denies the action because the user doesn’t have the right to call sts:AssumeRole.

By attaching this policy to a group, you give all users in the group the ability to attempt the assume-role call.

2️⃣ Why Both Are Needed

Trust Policy → “Can this principal ever assume this role?”

Acts as a gatekeeper.

Only the users listed here (or accounts/services) can assume the role.

User/Group Policy → “Is this principal allowed to call sts:AssumeRole?”

Grants the actual permission to call the API.

Attaching it to a group lets you manage multiple users easily.