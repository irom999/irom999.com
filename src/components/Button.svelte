<script lang="ts">
	import type { Snippet } from 'svelte';

	type Props = {
		variant?: 'primary' | 'secondary' | 'outline';
		href?: string;
		type?: 'button' | 'submit';
		children: Snippet;
	};

	const { variant = 'primary', href, type = 'button', children }: Props = $props();

	// variantによってスタイルを切り替え
	const variantStyles = {
		primary: 'bg-accent-100 text-white hover:bg-accent-200',
		secondary: 'bg-bg-200 text-text-100 hover:bg-bg-300',
		outline: 'border-2 border-accent-100 text-accent-100 hover:bg-accent-100 hover:text-white',
	};
</script>

{#if href}
	<!-- リンクの場合 -->
	<a
		{href}
		class={[variantStyles[variant], 'px-6 py-3 rounded-lg font-bold inline-block transition-base no-underline hover:scale-105 active:scale-95']}
	>
		{@render children()}
	</a>
{:else}
	<!-- ボタンの場合 -->
	<button
		{type}
		class={[variantStyles[variant], 'px-6 py-3 rounded-lg font-bold transition-base cursor-pointer hover:scale-105 active:scale-95']}
	>
		{@render children()}
	</button>
{/if}
