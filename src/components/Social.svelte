<script lang="ts">
	const { size = 4.5 }: { size?: number } = $props();

	const ICONS = [
		{ class: 'i-line-md:github-loop', url: 'https://github.com/irom999', label: 'github' },
	] as const;
</script>

<article
	style:--cols={ICONS.length}
	animate="duration-3000 keyframes-fade-in"
	gap-3
	gcc
	grid-cols-3
	class="sm:grid-cols-[repeat(var(--cols),minmax(0,1fr))]"
>
	{#each ICONS as { class: _class, url, label } (url)}
		<div
			cursor-pointer
			hover="scale-110 shadow-xl z-10 bg-[#88888811] op100"
			op-card
			transition-base
		>
			<a aria-label="link to irom999's {label}" href={url} rel="noopener noreferrer" target="_blank">
				<div
					style:--size="{size}vh"
					class={_class}
					text-size="[--size]"
				></div>
			</a>
		</div>
	{/each}
</article>
