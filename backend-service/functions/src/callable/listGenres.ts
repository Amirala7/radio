import { onCall } from "firebase-functions/v2/https";
import { requireAuth } from "../lib/auth";
import { cacheKey, withCache } from "../lib/cache";
import { asObject, optionalInt } from "../lib/input";
import { normalizeGenrePage } from "../lib/normalize";
import { RAPIDAPI_KEY, rapidApiGet } from "../lib/rapidapi";
import type { Genre, Page } from "../lib/types";

const TTL_SECONDS = 60 * 60 * 24 * 7; // 7d

export const listGenres = onCall(
  { secrets: [RAPIDAPI_KEY] },
  async (request) => {
    requireAuth(request);
    const d = asObject(request.data);
    const page = optionalInt(d.page, "page", 1, 1000) ?? 1;
    const limit = optionalInt(d.limit, "limit", 1, 100) ?? 100;

    const key = cacheKey("listGenres", { page, limit });
    return withCache<Page<Genre>>(key, TTL_SECONDS, async () => {
      const raw = await rapidApiGet("/genres", { page, limit });
      return normalizeGenrePage(raw, page, limit);
    });
  },
);
