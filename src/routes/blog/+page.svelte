<script lang="ts">
	const { data } = $props();
</script>

<div class="mxa px-10 pt-10">
	{#if data.posts.length === 0}
		<p class="text-text-400">まだ記事がありません。</p>
	{:else}
		{#each data.posts as post (post.slug)}
			<div class="my-2">
				<a class="group fyc gap-3 mr-5 op-card transition-base" href="/blog/{post.slug}">
					<div class="flex gap-2 items-start my-2">
						<span class="mt-0.5">
							<div class="blog-list-icon i-simple-icons-markdown"></div>
						</span>
						<p style:view-transition-name="blog-{post.slug}" class="gap-x-2">
							{post.title}
							<span class="op50 pl-2 text-sm truncate">{post.date}</span>
						</p>
					</div>
				</a>
			</div>
		{/each}
	{/if}
</div>

<style>
	a {
		--uno: hover: no-underline;
	}
</style>
