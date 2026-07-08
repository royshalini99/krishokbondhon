# Community & Q&A API Contract (draft v1)

Status: **not yet implemented on the backend.** This is the target shape
the Flutter app codes against (see `lib/services/community_service.dart`
and `lib/services/qna_service.dart`). Adjust field names here first, then
re-generate the Dart models — don't let the two drift independently.

All endpoints are relative to `ApiConstants.baseUrl` and require
`Authorization: Bearer <jwt>` unless noted. All list endpoints are
paginated with `?cursor=<opaque_string>&limit=<int, default 20>`.

---

## Community feed

### GET /community/feed
Query: `cursor`, `limit`, `tag` (optional, e.g. `Tomato`)

```json
{
  "items": [
    {
      "id": "p_123",
      "author": { "id": "u_1", "name": "Ratul Deb", "avatarUrl": null, "village": "Katigorah, Cachar" },
      "content": "Late blight showing up on my potato leaves...",
      "images": ["https://cdn.../img1.jpg"],
      "tags": ["Potato", "Late Blight"],
      "likeCount": 18,
      "commentCount": 6,
      "likedByMe": false,
      "createdAt": "2026-07-06T10:15:00Z"
    }
  ],
  "nextCursor": "eyJvZmZzZXQiOjIwfQ==",
  "hasMore": true
}
```

### POST /community/posts
Multipart form: `content` (string), `tags` (JSON array string), `images[]` (files, optional)
→ Returns the created post object (same shape as one `items[]` entry above).

### POST /community/posts/{id}/like
No body. Toggles like for the current user.
→ `{ "likeCount": 19, "likedByMe": true }`

### GET /community/posts/{id}/comments
Query: `cursor`, `limit`
```json
{
  "items": [
    { "id": "c_1", "author": { "name": "Silchan Marak" }, "content": "Same issue here...", "createdAt": "..." }
  ],
  "nextCursor": null,
  "hasMore": false
}
```

### POST /community/posts/{id}/comments
Body: `{ "content": "string" }` → returns created comment.

---

## Q&A

### GET /qna/questions
Query: `cursor`, `limit`, `crop` (optional), `status` (optional: `open`/`pending`/`answered`)
```json
{
  "items": [
    {
      "id": "q_1",
      "author": { "name": "Anupam Nath" },
      "title": "Yellow curling leaves on tomato...",
      "cropType": "Tomato",
      "imageUrl": null,
      "status": "answered",
      "createdAt": "...",
      "answers": [
        { "id": "a_2", "source": "expert", "authorName": "Dr. Bornali Gogoi", "content": "...", "verified": true, "createdAt": "..." },
        { "id": "a_1", "source": "ai", "authorName": "KrishokBondhon AI", "content": "...", "verified": false, "createdAt": "..." }
      ]
    }
  ],
  "nextCursor": "...",
  "hasMore": true
}
```
`status` is one of: `pending` (AI answer not generated yet), `answered`.
**Answers are returned with expert-verified answers first**, then AI,
then farmer answers — not strictly chronological.

### POST /qna/ask
Multipart or JSON body: `{ "title": "string", "cropType": "string", "imageUrl": "string?" }`
→ **Returns immediately** (HTTP 202) with the question object, `status: "pending"`,
`answers: []`. The NLP microservice processes async; the AI answer is appended
server-side once ready. The backend also attempts to notify matching experts
in the background (currently a no-op stub until the expert directory service
exists — see backend's `expertNotificationService.js`); this has no effect on
what the client receives back.

### GET /qna/questions/{id}
Same shape as one `items[]` entry above. **The app polls this** every ~4s
while `status == "pending"`, stopping once `status == "answered"` or an AI
answer appears in `answers`, whichever the backend considers "done."

### POST /qna/questions/{id}/answers
Body: `{ "content": "string" }` — for a farmer (or expert, if the JWT role
is `expert`) adding their own answer.
→ Returns the created answer; `source` is derived server-side from the
JWT role (`farmer` or `expert`), never trusted from the client.

---

## Future upgrade path (not built yet)

Swap polling for a push model: client joins a Socket.IO room named
`question:{id}` after calling `/qna/ask`; server emits `qna:answer` on
that room the moment the AI (or an expert) answers. `QnaService` already
isolates this behind one method (`watchQuestion`) so the screen layer
won't need to change when this lands — only the implementation inside
that method does.
