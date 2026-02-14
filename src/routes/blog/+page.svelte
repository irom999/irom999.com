<script lang="ts">
	const { data } = $props();
</script>

<div mxa px-10 pt-10>
	{#if data.posts.length === 0}
		<p text-text-400>まだ記事がありません。</p>
	{:else}
		{#each data.posts as post (post.slug)}
			<div my-2>
				<a
					class="group"
					fyc
					gap-3
					href="/blog/{post.slug}"
					mr-5
					op-card
					transition-base
				>
					<div flex gap-2 items-start my-2>
						<span mt-0.5>
							<div class="blog-list-icon i-simple-icons-markdown"></div>
						</span>
						<p
							style:view-transition-name="blog-{post.slug}"
							gap-x-2
						>
							{post.title}
							<span op50 pl-2 text-sm truncate>{post.date}</span>
						</p>
					</div>
				</a>
			</div>
		{/each}
	{/if}
</div>

<style>
a {
	--uno: hover:no-underline;
}
</style>
