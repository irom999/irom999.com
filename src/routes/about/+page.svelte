<script>
	import Button from '$components/Button.svelte';
</script>

<!-- ページ全体にフェードインアニメーション -->
<div mxa px-10 pt-10 max-w-3xl animate="duration-500 keyframes-fade-in">
	<!-- タイトルにスライドインアニメーション -->
	<!-- <h1 text-4xl mono-bold mb-8 animate="duration-800 keyframes-slide-in-top">About Me</h1> -->

	<!-- blogフォント -->
	<h1
		font="mono bold"
		text-5xl
		mb-8
		text-transparent
		style="-webkit-text-stroke: 2px #FB923C; text-stroke: 2px
  #FB923C;"
		hover:scale-110
		transition-transform
		duration-300
	>
		About Me
	</h1>

	<!-- シャッフルアニメーション -->
	<section mb-8>
		<h2 text-2xl font-bold mb-4>⚽ シャッフルアニメーション</h2>
		<div relative h-40 flex items-center justify-center>
			<div class="shuffle-container">
				<div class="ball shuffle-white"></div>
				<div class="ball shuffle-black"></div>
			</div>
		</div>
	</section>

	<!-- 光るフォント -->
	<h1
		font="mono bold"
		text-5xl
		mb-8
		text-accent-200
		style="text-shadow:
          0 0 10px #FB923C,
          0 0 20px #FB923C,
          0 0 30px #FB923C,
          0 0 40px #F97316;"
	>
		About Me
	</h1>

	<!-- 3D効果 -->
	<h1
		font="mono bold"
		text-5xl
		mb-8
		text-accent-200
		style="text-shadow:
          1px 1px 0 #F97316,
          2px 2px 0 #F97316,
          3px 3px 0 #C2410C,
          4px 4px 0 #C2410C,
          5px 5px 0 #7C2D12;"
	>
		About Me
	</h1>

	<!-- 脈打ちアニメーション -->
	<h1 font="mono bold" text-5xl mb-8 text-accent-200 animate-pulse hover:animate-none>About Me</h1>

	<h1
		font="mono bold"
		text-6xl
		mb-8
		bg-gradient-to-r
		from-pink-500
		via-purple-500
		to-indigo-500
		bg-clip-text
		text-transparent
		hover:scale-110
		hover:rotate-2
		transition-all
		duration-500
		cursor-pointer
		animate-pulse
		style="text-shadow:
          0 0 20px rgba(219, 39, 119, 0.5),
          0 0 30px rgba(168, 85, 247, 0.5),
          0 0 40px rgba(99, 102, 241, 0.5);"
	>
		About Me
	</h1>

	<!-- セクション1: フェードイン（遅延200ms） -->
	<section mb-8 animate="duration-1000 keyframes-fade-in" style="animation-delay: 200ms">
		<h2 text-2xl font-bold mb-4>👋 はじめまして</h2>
		<p text-lg leading-relaxed mb-4>irom999です。ソフトウェアエンジニアとして活動しています。</p>
		<p text-lg leading-relaxed>このサイトは、SvelteKitとUnoCSSを学びながら構築しています。</p>
	</section>

	<!-- セクション2: フェードイン（遅延400ms） -->
	<section mb-8 animate="duration-1000 keyframes-fade-in" style="animation-delay: 400ms">
		<h2 text-2xl font-bold mb-4>🛠️ スキル</h2>
		<div grid grid-cols="1 sm:2" gap-4>
			<div
				p-4
				bg-accent-200
				rounded
				transform
				hover:scale-110
				hover:rotate-10
				hover:bg-accent-300
				transition-all
				duration-300
				cursor-pointer
				class="dark:bg-bg-200"
			>
				<h3 font-bold mb-2>フロントエンド</h3>
				<ul list-disc list-inside space-y-1>
					<li>Svelte / SvelteKit</li>
					<li>UnoCSS</li>
					<li>TypeScript</li>
				</ul>
			</div>
			<div
				p-4
				bg-amber
				rounded
				transform
				hover:scale-105
				hover:rotate-1
				transition-all
				duration-300
				class="dark:bg-bg-300"
			>
				<h3 font-bold mb-2>その他</h3>
				<ul list-disc list-inside space-y-1>
					<li>Git / GitHub</li>
					<li>Cloudflare Pages</li>
					<li>Markdown</li>
				</ul>
			</div>
		</div>
	</section>

	<!-- セクション3: フェードイン（遅延600ms） -->
	<section mb-8 animate="duration-1000 keyframes-fade-in" style="animation-delay: 600ms">
		<h2 text-2xl font-bold mb-4>📫 連絡先</h2>
		<p text-lg mb-6>
			GitHub:
			<a
				href="https://github.com/irom999"
				target="_blank"
				rel="noopener noreferrer"
				text-accent-100
				class="hover:underline"
			>
				@irom999
			</a>
		</p>

		<!-- ボタンコンポーネントの使用例 -->
		<div flex gap-4 flex-wrap>
			<Button href="https://github.com/irom999" target="_blank">GitHubを見る</Button>
			<Button variant="secondary" href="/blog">ブログを読む</Button>
			<Button variant="outline" href="/">ホームへ戻る</Button>
		</div>
	</section>
</div>

<style>
	.ball {
		width: 50px;
		height: 50px;
		border-radius: 50%;
		position: absolute;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
	}

	.shuffle-container {
		position: relative;
		width: 120px;
		height: 60px;
	}

	.shuffle-white {
		background: #ffffff;
		animation: shuffle-white 2s ease-in-out infinite;
	}

	.shuffle-black {
		background: #000000;
		animation: shuffle-black 2s ease-in-out infinite;
	}

	@keyframes shuffle-white {
		0%,
		100% {
			left: 0;
		}
		50% {
			left: 60px;
		}
	}

	@keyframes shuffle-black {
		0%,
		100% {
			left: 60px;
		}
		50% {
			left: 0;
		}
	}
</style>
