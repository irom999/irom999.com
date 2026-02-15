<script lang="ts">
	type Props = {
		variant?: 'primary' | 'secondary' | 'outline';
		href?: string;
		type?: 'button' | 'submit';
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
		class={[variantStyles[variant], 'hover:scale-105 active:scale-95']}
		px-6
		py-3
		rounded-lg
		font-bold
		inline-block
		transition-base
		no-underline
	>
		{@render children()}
	</a>
{:else}
	<!-- ボタンの場合 -->
	<button
		{type}
		class={[variantStyles[variant], 'hover:scale-105 active:scale-95']}
		px-6
		py-3
		rounded-lg
		font-bold
		transition-base
		cursor-pointer
	>
		{@render children()}
	</button>
{/if}
