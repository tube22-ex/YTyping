CREATE TYPE "public"."category" AS ENUM('CSS', 'SPEED_SHIFT', 'CASE_SENSITIVE');--> statement-breakpoint
CREATE TYPE "public"."map_visibility" AS ENUM('PUBLIC', 'UNLISTED');--> statement-breakpoint
CREATE TYPE "public"."thumbnail_quality" AS ENUM('mqdefault', 'maxresdefault');--> statement-breakpoint
CREATE TYPE "public"."reading_conversion_dict_type" AS ENUM('DICTIONARY', 'REGEX');--> statement-breakpoint
CREATE TYPE "public"."type" AS ENUM('LIKE', 'CLAP', 'OVER_TAKE', 'MAP_BOOKMARK');--> statement-breakpoint
CREATE TYPE "public"."toggle_input_mode_key" AS ENUM('ALT_KANA', 'TAB', 'NONE');--> statement-breakpoint
CREATE TYPE "public"."line_completed_display" AS ENUM('HIGH_LIGHT', 'NEXT_WORD');--> statement-breakpoint
CREATE TYPE "public"."main_word_display" AS ENUM('KANA_ROMA_UPPERCASE', 'KANA_ROMA_LOWERCASE', 'ROMA_KANA_UPPERCASE', 'ROMA_KANA_LOWERCASE', 'KANA_ONLY', 'ROMA_UPPERCASE_ONLY', 'ROMA_LOWERCASE_ONLY');--> statement-breakpoint
CREATE TYPE "public"."map_list_layout" AS ENUM('TWO_COLUMNS', 'THREE_COLUMNS');--> statement-breakpoint
CREATE TYPE "public"."next_display" AS ENUM('LYRICS', 'WORD');--> statement-breakpoint
CREATE TYPE "public"."presence_state" AS ENUM('ONLINE', 'ASK_ME', 'HIDE_ONLINE');--> statement-breakpoint
CREATE TYPE "public"."role" AS ENUM('USER', 'ADMIN');--> statement-breakpoint
CREATE TYPE "public"."time_offset_key" AS ENUM('CTRL_LEFT_RIGHT', 'CTRL_ALT_LEFT_RIGHT', 'NONE');--> statement-breakpoint
CREATE TABLE "map_bookmark_list_items" (
	"list_id" integer NOT NULL,
	"map_id" integer NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "map_bookmark_list_items_list_id_map_id_pk" PRIMARY KEY("list_id","map_id")
);
--> statement-breakpoint
CREATE TABLE "map_bookmark_lists" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"title" varchar(256) NOT NULL,
	"is_public" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "map_difficulties" (
	"map_id" integer PRIMARY KEY NOT NULL,
	"roma_kpm_median" integer DEFAULT 0 NOT NULL,
	"roma_kpm_max" integer DEFAULT 0 NOT NULL,
	"kana_kpm_median" integer DEFAULT 0 NOT NULL,
	"kana_kpm_max" integer DEFAULT 0 NOT NULL,
	"roma_total_notes" integer DEFAULT 0 NOT NULL,
	"kana_total_notes" integer DEFAULT 0 NOT NULL,
	"kana_chunk_count" integer DEFAULT 0 NOT NULL,
	"alphabet_chunk_count" integer DEFAULT 0 NOT NULL,
	"num_chunk_count" integer DEFAULT 0 NOT NULL,
	"space_chunk_count" integer DEFAULT 0 NOT NULL,
	"symbol_chunk_count" integer DEFAULT 0 NOT NULL,
	"rating" real NOT NULL
);
--> statement-breakpoint
CREATE TABLE "map_likes" (
	"user_id" integer NOT NULL,
	"map_id" integer NOT NULL,
	"has_liked" boolean NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "map_likes_user_id_map_id_pk" PRIMARY KEY("user_id","map_id")
);
--> statement-breakpoint
CREATE TABLE "maps" (
	"id" integer PRIMARY KEY NOT NULL,
	"video_id" char(11) NOT NULL,
	"title" varchar(256) NOT NULL,
	"artist_name" varchar(256) NOT NULL,
	"music_source" varchar(256) NOT NULL,
	"creator_comment" varchar(1024) NOT NULL,
	"tags" text[] DEFAULT ARRAY[]::text[] NOT NULL,
	"creator_id" integer NOT NULL,
	"preview_time" real DEFAULT 0 NOT NULL,
	"duration" real DEFAULT 0 NOT NULL,
	"play_count" integer DEFAULT 0 NOT NULL,
	"like_count" integer DEFAULT 0 NOT NULL,
	"ranking_count" integer DEFAULT 0 NOT NULL,
	"category" "category"[] DEFAULT ARRAY[]::category[] NOT NULL,
	"thumbnail_quality" "thumbnail_quality" DEFAULT 'mqdefault' NOT NULL,
	"published_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"visibility" "map_visibility" NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "fix_word_edit_logs" (
	"lyrics" varchar PRIMARY KEY NOT NULL,
	"word" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "reading_conversion_dict" (
	"surface" varchar PRIMARY KEY NOT NULL,
	"reading" varchar NOT NULL,
	"type" "reading_conversion_dict_type" DEFAULT 'DICTIONARY' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notification_claps" (
	"notification_id" varchar PRIMARY KEY NOT NULL,
	"clapper_id" integer NOT NULL,
	"result_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notification_likes" (
	"notification_id" varchar PRIMARY KEY NOT NULL,
	"liker_id" integer NOT NULL,
	"map_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notification_map_bookmarks" (
	"notification_id" varchar PRIMARY KEY NOT NULL,
	"bookmarker_id" integer NOT NULL,
	"list_id" integer NOT NULL,
	"map_id" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notification_over_takes" (
	"notification_id" varchar PRIMARY KEY NOT NULL,
	"visitor_id" integer NOT NULL,
	"visited_id" integer NOT NULL,
	"map_id" integer NOT NULL,
	"prev_rank" integer
);
--> statement-breakpoint
CREATE TABLE "notifications" (
	"id" varchar PRIMARY KEY NOT NULL,
	"recipient_id" integer NOT NULL,
	"type" "type" NOT NULL,
	"checked" boolean DEFAULT false NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ime_results" (
	"id" integer PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"map_id" integer NOT NULL,
	"type_count" integer DEFAULT 0 NOT NULL,
	"score" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "result_claps" (
	"user_id" integer NOT NULL,
	"result_id" integer NOT NULL,
	"has_clapped" boolean NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "result_claps_user_id_result_id_pk" PRIMARY KEY("user_id","result_id")
);
--> statement-breakpoint
CREATE TABLE "result_statuses" (
	"result_id" integer PRIMARY KEY NOT NULL,
	"score" integer DEFAULT 0 NOT NULL,
	"min_play_speed" real DEFAULT 1 NOT NULL,
	"kpm" integer DEFAULT 0 NOT NULL,
	"rkpm" integer DEFAULT 0 NOT NULL,
	"kana_to_roma_kpm" integer DEFAULT 0 NOT NULL,
	"kana_to_roma_rkpm" integer DEFAULT 0 NOT NULL,
	"roma_type" integer DEFAULT 0 NOT NULL,
	"kana_type" integer DEFAULT 0 NOT NULL,
	"flick_type" integer DEFAULT 0 NOT NULL,
	"english_type" integer DEFAULT 0 NOT NULL,
	"space_type" integer DEFAULT 0 NOT NULL,
	"symbol_type" integer DEFAULT 0 NOT NULL,
	"num_type" integer DEFAULT 0 NOT NULL,
	"miss" integer DEFAULT 0 NOT NULL,
	"lost" integer DEFAULT 0 NOT NULL,
	"max_combo" integer DEFAULT 0 NOT NULL,
	"clear_rate" real DEFAULT 0 NOT NULL,
	"is_case_sensitive" boolean DEFAULT false NOT NULL,
	"star_rating_snapshot" real DEFAULT 0 NOT NULL,
	"pp" real DEFAULT 0 NOT NULL,
	CONSTRAINT "valid_play_speed_values" CHECK ("result_statuses"."min_play_speed" IN (0.25, 0.5, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00))
);
--> statement-breakpoint
CREATE TABLE "results" (
	"id" integer PRIMARY KEY NOT NULL,
	"map_id" integer NOT NULL,
	"user_id" integer NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"clap_count" integer DEFAULT 0 NOT NULL,
	"rank" integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "accounts" (
	"id" varchar PRIMARY KEY NOT NULL,
	"account_id" text NOT NULL,
	"provider_id" text NOT NULL,
	"user_id" integer NOT NULL,
	"access_token" text,
	"refresh_token" text,
	"id_token" text,
	"access_token_expires_at" timestamp,
	"refresh_token_expires_at" timestamp,
	"scope" text,
	"password" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sessions" (
	"id" varchar PRIMARY KEY NOT NULL,
	"expires_at" timestamp NOT NULL,
	"token" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp NOT NULL,
	"ip_address" text,
	"user_agent" text,
	"user_id" integer NOT NULL,
	"impersonated_by" text,
	CONSTRAINT "sessions_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "user_daily_type_counts" (
	"user_id" integer NOT NULL,
	"date" date NOT NULL,
	"roma_type_count" integer DEFAULT 0 NOT NULL,
	"kana_type_count" integer DEFAULT 0 NOT NULL,
	"flick_type_count" integer DEFAULT 0 NOT NULL,
	"english_type_count" integer DEFAULT 0 NOT NULL,
	"ime_type_count" integer DEFAULT 0 NOT NULL,
	"other_type_count" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "user_daily_type_counts_user_id_date_pk" PRIMARY KEY("user_id","date")
);
--> statement-breakpoint
CREATE TABLE "user_ime_typing_options" (
	"user_id" integer PRIMARY KEY NOT NULL,
	"enable_include_regex" boolean DEFAULT false NOT NULL,
	"insert_english_spaces" boolean DEFAULT false NOT NULL,
	"is_case_sensitive" boolean DEFAULT false NOT NULL,
	"enable_next_lyrics" boolean DEFAULT true NOT NULL,
	"include_regex_pattern" varchar(1024) DEFAULT '' NOT NULL,
	"enable_large_video_display" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_map_completion_play_counts" (
	"user_id" integer NOT NULL,
	"map_id" integer NOT NULL,
	"count" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "user_map_completion_play_counts_user_id_map_id_pk" PRIMARY KEY("user_id","map_id")
);
--> statement-breakpoint
CREATE TABLE "user_options" (
	"user_id" integer PRIMARY KEY NOT NULL,
	"presence_state" "presence_state" DEFAULT 'ONLINE' NOT NULL,
	"hide_user_stats" boolean DEFAULT false NOT NULL,
	"map_list_layout" "map_list_layout" DEFAULT 'TWO_COLUMNS' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_profiles" (
	"user_id" integer PRIMARY KEY NOT NULL,
	"finger_chart_url" varchar(256) DEFAULT '' NOT NULL,
	"keyboard" varchar(1024) DEFAULT '' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_stats" (
	"user_id" integer PRIMARY KEY NOT NULL,
	"total_ranking_count" integer DEFAULT 0 NOT NULL,
	"total_typing_time" real DEFAULT 0 NOT NULL,
	"roma_type_total_count" integer DEFAULT 0 NOT NULL,
	"kana_type_total_count" integer DEFAULT 0 NOT NULL,
	"flick_type_total_count" integer DEFAULT 0 NOT NULL,
	"english_type_total_count" integer DEFAULT 0 NOT NULL,
	"space_type_total_count" integer DEFAULT 0 NOT NULL,
	"symbol_type_total_count" integer DEFAULT 0 NOT NULL,
	"num_type_total_count" integer DEFAULT 0 NOT NULL,
	"total_play_count" integer DEFAULT 0 NOT NULL,
	"ime_type_total_count" integer DEFAULT 0 NOT NULL,
	"max_combo" integer DEFAULT 0 NOT NULL,
	"total_pp" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_typing_options" (
	"user_id" integer PRIMARY KEY NOT NULL,
	"time_offset" real DEFAULT 0 NOT NULL,
	"main_word_scroll_start" integer DEFAULT 35 NOT NULL,
	"sub_word_scroll_start" integer DEFAULT 40 NOT NULL,
	"is_smooth_scroll" boolean DEFAULT true NOT NULL,
	"main_word_font_size" integer DEFAULT 100 NOT NULL,
	"sub_word_font_size" integer DEFAULT 90 NOT NULL,
	"main_word_top_position" real DEFAULT 0 NOT NULL,
	"sub_word_top_position" real DEFAULT 0 NOT NULL,
	"kana_word_spacing" real DEFAULT 0 NOT NULL,
	"roma_word_spacing" real DEFAULT 0.02 NOT NULL,
	"type_sound" boolean DEFAULT false NOT NULL,
	"miss_sound" boolean DEFAULT false NOT NULL,
	"completed_type_sound" boolean DEFAULT true NOT NULL,
	"next_display" "next_display" DEFAULT 'LYRICS' NOT NULL,
	"line_completed_display" "line_completed_display" DEFAULT 'NEXT_WORD' NOT NULL,
	"time_offset_adjust_key" time_offset_key DEFAULT 'CTRL_LEFT_RIGHT' NOT NULL,
	"input_mode_toggle_key" "toggle_input_mode_key" DEFAULT 'ALT_KANA' NOT NULL,
	"main_word_display" "main_word_display" DEFAULT 'KANA_ROMA_UPPERCASE' NOT NULL,
	"is_case_sensitive" boolean DEFAULT false NOT NULL,
	"window_scale_width" integer DEFAULT 1160 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar,
	"email_hash" varchar NOT NULL,
	"role" "role" DEFAULT 'USER' NOT NULL,
	"email_verified" boolean DEFAULT true NOT NULL,
	"image" text,
	"banned" boolean DEFAULT false,
	"ban_reason" text,
	"ban_expires" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "users_name_unique" UNIQUE("name"),
	CONSTRAINT "users_email_hash_unique" UNIQUE("email_hash")
);
--> statement-breakpoint
CREATE TABLE "verifications" (
	"id" varchar PRIMARY KEY NOT NULL,
	"identifier" text NOT NULL,
	"value" text NOT NULL,
	"expires_at" timestamp NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp NOT NULL
);
--> statement-breakpoint
ALTER TABLE "map_bookmark_list_items" ADD CONSTRAINT "map_bookmark_list_items_list_id_map_bookmark_lists_id_fk" FOREIGN KEY ("list_id") REFERENCES "public"."map_bookmark_lists"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "map_bookmark_list_items" ADD CONSTRAINT "map_bookmark_list_items_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "map_bookmark_lists" ADD CONSTRAINT "map_bookmark_lists_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "map_difficulties" ADD CONSTRAINT "map_difficulties_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "map_likes" ADD CONSTRAINT "map_likes_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "map_likes" ADD CONSTRAINT "map_likes_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "maps" ADD CONSTRAINT "maps_creator_id_users_id_fk" FOREIGN KEY ("creator_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_claps" ADD CONSTRAINT "notification_claps_notification_id_notifications_id_fk" FOREIGN KEY ("notification_id") REFERENCES "public"."notifications"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_claps" ADD CONSTRAINT "notification_claps_clapper_id_users_id_fk" FOREIGN KEY ("clapper_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_claps" ADD CONSTRAINT "notification_claps_result_id_results_id_fk" FOREIGN KEY ("result_id") REFERENCES "public"."results"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_likes" ADD CONSTRAINT "notification_likes_notification_id_notifications_id_fk" FOREIGN KEY ("notification_id") REFERENCES "public"."notifications"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_likes" ADD CONSTRAINT "notification_likes_liker_id_users_id_fk" FOREIGN KEY ("liker_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_likes" ADD CONSTRAINT "notification_likes_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_map_bookmarks" ADD CONSTRAINT "notification_map_bookmarks_notification_id_notifications_id_fk" FOREIGN KEY ("notification_id") REFERENCES "public"."notifications"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_map_bookmarks" ADD CONSTRAINT "notification_map_bookmarks_bookmarker_id_users_id_fk" FOREIGN KEY ("bookmarker_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_map_bookmarks" ADD CONSTRAINT "notification_map_bookmarks_list_id_map_bookmark_lists_id_fk" FOREIGN KEY ("list_id") REFERENCES "public"."map_bookmark_lists"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_map_bookmarks" ADD CONSTRAINT "notification_map_bookmarks_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_over_takes" ADD CONSTRAINT "notification_over_takes_notification_id_notifications_id_fk" FOREIGN KEY ("notification_id") REFERENCES "public"."notifications"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_over_takes" ADD CONSTRAINT "notification_over_takes_visitor_id_users_id_fk" FOREIGN KEY ("visitor_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notification_over_takes" ADD CONSTRAINT "notification_over_takes_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_recipient_id_users_id_fk" FOREIGN KEY ("recipient_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ime_results" ADD CONSTRAINT "ime_results_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ime_results" ADD CONSTRAINT "ime_results_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "result_claps" ADD CONSTRAINT "result_claps_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "result_claps" ADD CONSTRAINT "result_claps_result_id_results_id_fk" FOREIGN KEY ("result_id") REFERENCES "public"."results"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "result_statuses" ADD CONSTRAINT "result_statuses_result_id_results_id_fk" FOREIGN KEY ("result_id") REFERENCES "public"."results"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "results" ADD CONSTRAINT "results_map_id_maps_id_fk" FOREIGN KEY ("map_id") REFERENCES "public"."maps"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "results" ADD CONSTRAINT "results_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_daily_type_counts" ADD CONSTRAINT "user_daily_type_counts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_ime_typing_options" ADD CONSTRAINT "user_ime_typing_options_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_map_completion_play_counts" ADD CONSTRAINT "user_map_completion_play_counts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_options" ADD CONSTRAINT "user_options_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_profiles" ADD CONSTRAINT "user_profiles_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_stats" ADD CONSTRAINT "user_stats_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_typing_options" ADD CONSTRAINT "user_typing_options_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "uq_notification_claps_clapper_id_result_id" ON "notification_claps" USING btree ("clapper_id","result_id");--> statement-breakpoint
CREATE UNIQUE INDEX "uq_notification_likes_liker_id_map_id" ON "notification_likes" USING btree ("liker_id","map_id");--> statement-breakpoint
CREATE UNIQUE INDEX "uq_notification_map_bookmarks_bookmarker_id_list_id_map_id" ON "notification_map_bookmarks" USING btree ("bookmarker_id","list_id","map_id");--> statement-breakpoint
CREATE UNIQUE INDEX "uq_notification_over_takes_visitor_id_visited_id_map_id" ON "notification_over_takes" USING btree ("visitor_id","visited_id","map_id");--> statement-breakpoint
CREATE UNIQUE INDEX "uq_results_user_id_map_id" ON "results" USING btree ("user_id","map_id");--> statement-breakpoint
CREATE INDEX "accounts_userId_idx" ON "accounts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "sessions_userId_idx" ON "sessions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "user_stats_total_pp_idx" ON "user_stats" USING btree ("total_pp");