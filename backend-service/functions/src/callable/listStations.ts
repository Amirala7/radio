import { onCall } from "firebase-functions/v2/https";
import { requireAuth } from "../lib/auth";
import { cacheKey, withCache } from "../lib/cache";
import { asObject, optionalInt } from "../lib/input";
import { normalizePage } from "../lib/normalize";
import { RAPIDAPI_KEY, rapidApiGet } from "../lib/rapidapi";
import type { Page, Station } from "../lib/types";

const TTL_SECONDS = 60 * 60; // 1h

export const listStations = onCall(
  { secrets: [RAPIDAPI_KEY] },
  async (request) => {
    requireAuth(request);
    const d = asObject(request.data);
    const page = optionalInt(d.page, "page", 1, 1000) ?? 1;
    const limit = optionalInt(d.limit, "limit", 1, 100) ?? 20;

    const key = cacheKey("listStations", { page, limit });
    return withCache<Page<Station>>(key, TTL_SECONDS, async () => {
      const raw = await rapidApiGet("/radios", { page, limit });
      return normalizePage(raw, page, limit);
    });
  },
);
